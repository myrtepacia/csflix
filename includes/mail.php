<?php
declare(strict_types=1);

if (!defined('CSFLIX_BOOTSTRAPPED')) {
    http_response_code(404);
    exit;
}

/**
 * Emails the customer their receipt once a booking is paid, through Resend.
 * $method is how it was paid ("GCash"), when known. Does nothing until the
 * 'mail' settings in config.php have a key. Never throws: a failed email must
 * not undo a payment.
 */
function send_booking_receipt(int $bookingId, string $method = ''): void
{
    $settings = (array) config('mail', []);
    if ((string) ($settings['resend_api_key'] ?? '') === '') {
        return;
    }
    try {
        $booking = find_booking_by_id($bookingId);
        if ($booking === null || $booking['status'] !== 'paid') {
            return;
        }
        $email = booking_receipt_email($booking, $method);
        resend_send_email($settings, (string) $booking['customer_email'], $email['subject'], $email['html'], $email['text'],
            'receipt-' . $booking['reference']);
    } catch (Throwable $e) {
        error_log('[receipt] booking ' . $bookingId . ': ' . $e->getMessage());
    }
}

// The look shared by every CSFlix email, after PayMongo's receipt
const EMAIL_FONT = "font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif";
const EMAIL_DARK = '#101828';
const EMAIL_RED = '#e40014';
const EMAIL_LABEL = '<span style="color:#969696;font-size:14px;line-height:25px">';
const EMAIL_VALUE = '<span style="font-size:16px;line-height:24px;color:#333333">';
const EMAIL_BOX = 'background-color:#f9fafb;padding:14px 24px;border-bottom:1px solid #ffffff';
// The banner title and the footer's name: a light red, like the logo's arrow
const EMAIL_TITLE_RED = '#ff4b3a';
// The logo goes inside every email as an inline picture with this id
const EMAIL_LOGO_CID = 'csflix-logo';

/**
 * A whole CSFlix email around $rows (<tr>s, two columns wide): the banner on
 * top with $banner ("Verify Email") on the left and the logo on the right,
 * then the rows, then the dark footer with $why ("You're receiving this
 * e-mail because..."). $preview is the line inbox lists show after the
 * subject.
 */
function email_html(string $title, string $preview, string $rows, string $why, string $banner = ''): string
{
    $link = email_site_url();
    return '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">'
        . '<title>' . e($title) . '</title></head>'
        . '<body style="margin:0;padding:0;background-color:#f9fafb;' . EMAIL_FONT . '">'
        . '<div style="display:none;font-size:1px;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden">' . e($preview) . '</div>'
        // Phone width everywhere, so a desktop inbox shows it as a phone does
        . '<div style="max-width:400px;margin:0 auto">'
        . '<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#ffffff;border-collapse:collapse;table-layout:fixed;' . EMAIL_FONT . '">'
        // The banner: what the email is on the left, the logo on the right. The
        // logo is sent inside the email (resend_send_email attaches it as
        // EMAIL_LOGO_CID), so it shows without the app downloading anything;
        // it opens the site
        . '<tr><td colspan="2" style="padding:14px 24px;background-color:' . EMAIL_DARK . ';border-bottom:4px solid ' . EMAIL_RED . '">'
        . '<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="border-collapse:collapse"><tr>'
        . '<td style="vertical-align:middle;font-size:20px;line-height:26px;font-weight:800;color:' . EMAIL_TITLE_RED . ';white-space:nowrap">' . e(mb_strtoupper($banner)) . '</td>'
        . '<td align="right" style="vertical-align:middle;text-align:right"><a href="' . e($link) . '" target="_blank" style="display:inline-block">'
        . '<img src="cid:' . EMAIL_LOGO_CID . '" alt="CSFlix" width="70" height="30" style="display:block;border:0;width:70px;height:30px"></a></td>'
        . '</tr></table></td></tr>'
        . $rows
        . '<tr><td colspan="2" style="padding:8px 16px;background-color:' . EMAIL_DARK . ';border-top:4px solid ' . EMAIL_RED . ';text-align:center;' . EMAIL_FONT . ';font-size:11px;line-height:15px;color:#ffffff">'
        . e($why) . '<br>'
        . '<strong style="color:' . EMAIL_TITLE_RED . '">CSFlix Cinema</strong>'
        . '</td></tr>'
        . '</table></div></body></html>';
}

/** The website the emails link to: app_url, or csflix.app when that is this computer. */
function email_site_url(): string
{
    $url = rtrim((string) config('app_url'), '/');
    $host = (string) parse_url($url, PHP_URL_HOST);
    return $host === '' || $host === 'localhost' || strpos($host, '127.') === 0 ? 'https://csflix.app' : $url;
}

/** The heading row: the big title (none when ''), then $after (HTML). */
function email_heading(string $title, string $after = ''): string
{
    return '<tr><td colspan="2" style="padding:24px 24px 0">'
        . ($title !== '' ? '<h1 style="margin:0;font-size:32px;line-height:38px;color:' . EMAIL_DARK . '">' . e($title) . '</h1>' : '')
        . $after
        . '</td></tr>';
}

/** "Hi Juan," and a paragraph (HTML). */
function email_greeting(string $name, string $html): string
{
    return '<tr><td colspan="2" style="padding:16px 24px 20px;font-size:14px;color:#555555">'
        . '<p style="margin:10px 0;font-size:20px;line-height:30px;color:#333333">Hi ' . e($name) . ',</p>'
        . '<p style="margin:0;font-size:16px;line-height:24px">' . $html . '</p>'
        . '</td></tr>';
}

/** A grey box with a small label over $html. $first adds the line above. */
function email_field(string $label, string $html, bool $first = false): string
{
    return '<tr><td colspan="2" style="' . EMAIL_BOX . ($first ? ';border-top:1px solid #d4dae3' : '') . '">'
        . EMAIL_LABEL . e($label) . '</span><br>' . $html . '</td></tr>';
}

/** A closing note (HTML), centred on white under a line. */
function email_note(string $html): string
{
    return '<tr><td colspan="2" style="padding:16px 24px;border-top:1px solid #d4dae3;text-align:center;font-size:14px;line-height:22px;color:#555555">'
        . $html . '</td></tr>';
}

/**
 * The receipt for a paid booking: ['subject', 'html', 'text'], laid
 * out like PayMongo's own receipt, with the CSFlix banner on top.
 */
function booking_receipt_email(array $booking, string $method = ''): array
{
    $shop = 'CSFlix Cinema';
    $reference = (string) $booking['reference'];
    $name = (string) $booking['customer_name'];
    $peso = static function (int $amount): string {
        return "\u{20B1} " . number_format($amount, 2);
    };

    // What was bought: [what, line total], the same lines PayMongo listed
    $lines = [];
    foreach (booking_line_items($booking) as $item) {
        $lines[] = [
            $item['name'] . ' (' . $peso($item['amount']) . ') x ' . $item['quantity'],
            $peso($item['amount'] * $item['quantity']),
        ];
    }
    $total = $peso((int) $booking['total']);
    $paidAt = !empty($booking['paid_at']) ? (new DateTimeImmutable((string) $booking['paid_at']))->format('Y-m-d H:i:s O') : '';

    // Plain text
    $text = "Reference: #$reference\n\n"
        . "Hi $name,\n\nThank you for your payment. Here's a copy of your receipt.\n\n"
        . "Order details\n";
    foreach ($lines as [$what, $amount]) {
        $text .= "$what    $amount\n";
    }
    $text .= "\nAmount paid\n$total\n\n";
    if ($method !== '') {
        $text .= "Payment method\n$method\n\n";
    }
    if ($paidAt !== '') {
        $text .= "Date paid\n$paidAt\n\n";
    }
    $text .= "You're receiving this e-mail because you made a purchase at $shop.\n";

    // HTML
    $orderRows = '';
    foreach ($lines as [$what, $amount]) {
        $orderRows .= '<tr>'
            . '<td style="padding:5px 0;vertical-align:top">' . EMAIL_VALUE . e($what) . '</span></td>'
            . '<td style="padding:5px 0 5px 16px;vertical-align:top;text-align:right;white-space:nowrap">' . EMAIL_VALUE . e($amount) . '</span></td>'
            . '</tr>';
    }

    // Payment method and date paid share a row, as on PayMongo's receipt
    $methodRow = '';
    if ($method !== '' || $paidAt !== '') {
        $methodRow = '<tr>'
            . '<td style="' . EMAIL_BOX . ';width:50%;vertical-align:top">'
            . ($method !== '' ? EMAIL_LABEL . 'Payment method</span><br>' . EMAIL_VALUE . e($method) . '</span>' : '') . '</td>'
            . '<td style="background-color:#f9fafb;padding:20px;border-left:1px solid #ffffff;border-bottom:1px solid #ffffff;vertical-align:top">'
            . ($paidAt !== '' ? EMAIL_LABEL . 'Date paid</span><br>' . EMAIL_VALUE . e($paidAt) . '</span>' : '') . '</td>'
            . '</tr>';
    }

    $rows = email_heading('',
            '<p style="margin:0;font-size:16px;line-height:24px;color:' . EMAIL_DARK . '">Reference: <span style="color:' . EMAIL_RED . ';font-weight:700">#' . e($reference) . '</span></p>')
        . email_greeting($name, 'Thank you for your payment. Here\'s a copy of your receipt.')
        . email_field('Order details', '<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="border-collapse:collapse">' . $orderRows . '</table>', true)
        . email_field('Amount paid', '<span style="font-size:24px;line-height:36px;font-weight:700;color:#555555">' . e($total) . '</span>')
        . $methodRow;

    return [
        'subject' => 'Your receipt from ' . $shop . ' #' . $reference,
        'html'    => email_html('Your receipt from ' . $shop, 'Thank you for your payment to ' . $shop . '.', $rows,
            'You\'re receiving this e-mail because you made a purchase at ' . $shop . '.', 'Payment Receipt'),
        'text'    => $text,
    ];
}

/**
 * Emails a "forgot password" link. Throws RuntimeException if email is not
 * set up or Resend refuses it.
 */
function send_password_reset_email(array $user, string $link): void
{
    $settings = (array) config('mail', []);
    if ((string) ($settings['resend_api_key'] ?? '') === '') {
        throw new RuntimeException('Email is not set up: add RESEND_API_KEY to .env.');
    }
    $email = password_reset_email($user, $link);
    resend_send_email($settings, (string) $user['email'], $email['subject'], $email['html'], $email['text']);
}

/** The "forgot password" email: ['subject', 'html', 'text']. */
function password_reset_email(array $user, string $link): array
{
    $minutes = intdiv(RESET_LINK_SECONDS, 60);
    $firstName = strtok(trim((string) $user['name']), ' ') ?: 'there';
    $why = 'You\'re receiving this e-mail because a password reset was asked for your CSFlix account.';

    $text = "Reset your password\n\nHi $firstName,\n\n"
        . "Someone asked to reset the password of your CSFlix account. To choose a new password, open this link. It works once, for $minutes minutes:\n\n"
        . "$link\n\n"
        . "If it was not you, ignore this email: your password stays the same.\n\n"
        . "$why\n";

    $rows = email_greeting($firstName, 'Someone asked to reset the password of your CSFlix account. It works once, for ' . $minutes . ' minutes.')
        // Centred like the sign-up code: the button, then the link for when it fails
        . '<tr><td colspan="2" style="' . EMAIL_BOX . ';padding:16px 20px 20px;border-top:1px solid #d4dae3;text-align:center">'
        . EMAIL_LABEL . 'New password</span><br>'
        . '<a href="' . e($link) . '" style="display:inline-block;margin:10px 0 20px;background-color:' . EMAIL_RED . ';color:#ffffff;font-size:16px;font-weight:700;text-decoration:none;padding:12px 24px;border-radius:10px">Reset password</a><br>'
        . EMAIL_LABEL . 'Button not working?</span><br>'
        . '<span style="font-size:13px;line-height:20px;color:#333333;word-break:break-all">' . e($link) . '</span>'
        . '</td></tr>'
        . email_note('If it was not you, ignore this email: your password stays the same.');

    return [
        'subject' => 'Reset your CSFlix password',
        'html'    => email_html('Reset your CSFlix password', 'Choose a new password for your CSFlix account.', $rows, $why, 'Reset password'),
        'text'    => $text,
    ];
}

/**
 * Emails the 6-digit sign-up code. Throws RuntimeException if email is not
 * set up or Resend refuses it.
 */
function send_signup_code_email(string $email, string $code): void
{
    $settings = (array) config('mail', []);
    if ((string) ($settings['resend_api_key'] ?? '') === '') {
        throw new RuntimeException('Email is not set up: add RESEND_API_KEY to .env.');
    }
    $message = signup_code_email($code);
    resend_send_email($settings, $email, $message['subject'], $message['html'], $message['text']);
}

/** The sign-up code email: ['subject', 'html', 'text']. */
function signup_code_email(string $code): array
{
    $minutes = intdiv(SIGNUP_CODE_SECONDS, 60);
    $why = 'You\'re receiving this e-mail because this address was used to sign up at CSFlix Cinema.';

    $text = "Verify your email\n\nYour CSFlix verification code is: $code\n\n"
        . "Enter it to confirm this email. It works for $minutes minutes.\n\n"
        . "If you did not try to create a CSFlix account, ignore this email.\n\n"
        . "$why\n";

    // The code as plain large digits in the middle: no boxes or grey band, and
    // one piece of text, so it copies in one go. The padding on the left
    // balances the spacing after the last digit
    $rows = '<tr><td colspan="2" style="padding:20px 24px 0;font-size:16px;line-height:24px;color:#555555">'
        . 'Enter this code to confirm your email. It works for ' . $minutes . ' minutes.</td></tr>'
        . '<tr><td colspan="2" style="padding:16px 12px 20px;text-align:center">'
        . EMAIL_LABEL . 'Verification code</span><br>'
        . '<span style="display:inline-block;margin-top:6px;padding-left:12px;font-size:40px;line-height:48px;font-weight:800;letter-spacing:12px;color:' . EMAIL_DARK . '">'
        . e($code) . '</span>'
        . '</td></tr>'
        . email_note(e($why));

    return [
        'subject' => 'Your CSFlix code: ' . $code,
        'html'    => email_html('Your CSFlix code', 'Your verification code is ' . $code . '.', $rows,
            'If you did not try to create a CSFlix account, ignore this email.', 'Verify email'),
        'text'    => $text,
    ];
}

/**
 * Sends one email through Resend's API (resend.com). $idempotencyKey stops a
 * repeat of the same send from going out twice. Throws RuntimeException.
 */
function resend_send_email(array $settings, string $to, string $subject, string $html, string $text, string $idempotencyKey = ''): void
{
    if (!filter_var($to, FILTER_VALIDATE_EMAIL)) {
        throw new RuntimeException('Not a valid email address.');
    }
    $headers = [
        'Authorization: Bearer ' . (string) $settings['resend_api_key'],
        'Content-Type: application/json',
        'Accept: application/json',
    ];
    if ($idempotencyKey !== '') {
        $headers[] = 'Idempotency-Key: ' . $idempotencyKey;
    }
    $message = [
        'from'    => (string) ($settings['from'] ?? 'CSFlix Cinema <no-reply@csflix.app>'),
        'to'      => [$to],
        'subject' => $subject,
        'html'    => $html,
        'text'    => $text,
    ];
    // Replies go to the cinema's own inbox, not the no-reply sender
    if (filter_var((string) ($settings['support_email'] ?? ''), FILTER_VALIDATE_EMAIL)) {
        $message['reply_to'] = (string) $settings['support_email'];
    }
    // The banner's logo travels inside the email (src="cid:...")
    $logo = APP_ROOT . '/assets/img/logo.png';
    if (strpos($html, 'cid:' . EMAIL_LOGO_CID) !== false && is_file($logo)) {
        $message['attachments'] = [[
            'filename'   => 'csflix-logo.png',
            'content'    => base64_encode((string) file_get_contents($logo)),
            'content_id' => EMAIL_LOGO_CID,
        ]];
    }

    $curl = curl_init('https://api.resend.com/emails');
    curl_setopt_array($curl, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => json_encode($message, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE),
        CURLOPT_HTTPHEADER     => $headers,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_TIMEOUT        => 20,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_SSL_VERIFYHOST => 2,
        CURLOPT_PROTOCOLS      => CURLPROTO_HTTPS,
    ]);
    $raw = curl_exec($curl);
    $status = (int) curl_getinfo($curl, CURLINFO_RESPONSE_CODE);
    $error = curl_error($curl);

    if ($raw === false) {
        throw new RuntimeException('Could not reach Resend: ' . $error);
    }
    if ($status >= 400) {
        $reply = json_decode((string) $raw, true);
        throw new RuntimeException('Resend refused the email (HTTP ' . $status . '): ' . ($reply['message'] ?? substr((string) $raw, 0, 200)));
    }
}
