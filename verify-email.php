<?php
declare(strict_types=1);

require __DIR__ . '/includes/bootstrap.php';

redirect_if_signed_in();

// Step 2 of signing up: the 6-digit code signup.php emailed. The right code
// makes the account (verify-email.js moves between the boxes)
$pending = $_SESSION['signup_pending'] ?? null;
if (!is_array($pending)) {
    redirect('signup.php');
}
$email = (string) $pending['email'];

// Where to go after signing up (only paths inside the site)
$return = signin_return_path();

/** The six boxes as one code, or '' unless they hold six digits. */
function verify_email_code(array $post): string
{
    $digits = $post['digit'] ?? [];
    if (!is_array($digits)) {
        return '';
    }
    $code = implode('', array_map(static function ($digit): string {
        return is_string($digit) ? trim($digit) : '';
    }, array_slice($digits, 0, 6)));
    return preg_match('/^\d{6}$/', $code) ? $code : '';
}

$error = '';
$notice = '';

if (is_post()) {
    verify_csrf();

    if (input_string($_POST, 'action', 10) === 'resend') {
        $wait = (int) $pending['sent_at'] + SIGNUP_CODE_RESEND_SECONDS - time();
        if ($wait > 0) {
            // Too soon: nothing is sent and nothing is said (the countdown on
            // Resend code already shows the wait)
        } elseif (signup_send_code()) {
            $notice = 'We sent a new code. Check your inbox.';
        } else {
            $error = 'We could not send the code just now. Please try again in a moment.';
        }
    } else {
        $code = verify_email_code($_POST);
        if ((int) $pending['expires'] < time()) {
            $error = 'This code has expired. Press Resend code for a new one.';
        } elseif ($code === '') {
            $error = 'Enter the 6-digit code from the email.';
        } elseif (hash_equals((string) $pending['hash'], signup_code_hash($email, $code))) {
            unset($_SESSION['signup_pending']);
            try {
                db_exec(
                    "INSERT INTO users (name, email, mobile, password_hash, role) VALUES (?, ?, ?, ?, 'customer')",
                    [$pending['name'], $email, $pending['mobile'], $pending['password_hash']]
                );
                $userId = (int) db()->lastInsertId();
            } catch (PDOException $e) {
                // Registered meanwhile (another tab): the unique key lets
                // only one through
                if (!is_duplicate_key($e)) {
                    throw $e;
                }
                $_SESSION['signin_notice'] = 'An account with that email already exists. Sign in instead.';
                redirect('signin.php');
            }
            login_user(['id' => $userId]);
            redirect($return ?? 'index.php');
        } else {
            $tries = (int) $pending['tries'] + 1;
            if ($tries >= SIGNUP_CODE_TRIES) {
                $_SESSION['signup_pending']['expires'] = 0;
                $error = 'Too many wrong codes. Press Resend code for a new one.';
            } else {
                $_SESSION['signup_pending']['tries'] = $tries;
                $left = SIGNUP_CODE_TRIES - $tries;
                $error = 'That code is not right. ' . $left . ($left === 1 ? ' try' : ' tries') . ' left.';
            }
        }
    }
    $pending = $_SESSION['signup_pending'];
}

$resendIn = max(0, (int) $pending['sent_at'] + SIGNUP_CODE_RESEND_SECONDS - time());

render_head('Verify Your Email');
render_header();
?>
  <main class="form-page">
    <div class="form-card">

      <h1>Check your email</h1>
      <p class="form-intro">Enter the 6-digit code we sent to <strong><?= e($email) ?></strong>. It works for <?= e(intdiv(SIGNUP_CODE_SECONDS, 60)) ?> minutes.<br>
        <a class="link-button otp-change" href="<?= e(url('signup.php')) ?>">Change email</a></p>

<?php if ($error !== ''): ?>
      <p class="form-message form-message-error" id="form-message" role="alert"><?= e($error) ?></p>
<?php elseif ($notice !== ''): ?>
      <p class="form-message form-message-success" role="status"><?= e($notice) ?></p>
<?php endif; ?>

      <form id="verify-form" method="post" action="<?= e(url('verify-email.php')) ?>">
        <?= csrf_field() ?>
        <div class="form-field">
          <div class="otp-boxes" id="otp-boxes" role="group" aria-label="6-digit code">
<?php for ($digit = 1; $digit <= 6; $digit++): ?>
            <input class="otp-box" type="text" name="digit[]" inputmode="numeric" pattern="[0-9]*" maxlength="1" required
                   autocomplete="<?= $digit === 1 ? 'one-time-code' : 'off' ?>" aria-label="<?= e('Digit ' . $digit) ?>"<?= $digit === 1 ? ' autofocus' : '' ?>>
<?php endfor; ?>
          </div>
        </div>
        <button class="button button-red" type="submit" id="submit">Verify and Create Account</button>
      </form>

      <div class="otp-actions">
        <form method="post" action="<?= e(url('verify-email.php')) ?>">
          <?= csrf_field() ?>
          <input type="hidden" name="action" value="resend">
          <span>Didn't get it?</span>
          <button class="link-button" type="submit" id="otp-resend" data-wait="<?= e($resendIn) ?>">Resend code</button>
        </form>
      </div>

    </div>
  </main>

<?php render_footer(['js' => ['assets/js/verify-email.js']]);
