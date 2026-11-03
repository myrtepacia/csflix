// Verify Email: one digit per box. Typing moves to the next box, Backspace
// to the one before, a pasted or suggested code fills them all, and the
// form goes as soon as six digits are in. Resend code waits out its minute.
(function () {
  'use strict';

  var form = document.getElementById('verify-form');
  var boxes = Array.prototype.slice.call(document.querySelectorAll('#otp-boxes .otp-box'));
  if (!form || boxes.length === 0) {
    return;
  }

  var sent = false;

  function full() {
    return boxes.every(function (box) {
      return /^\d$/.test(box.value);
    });
  }

  function submitIfFull() {
    if (!sent && full()) {
      sent = true;
      form.submit();
    }
  }

  // Fill the boxes from position `from` with the digits in `text`
  function fill(from, text) {
    var digits = text.replace(/\D/g, '').split('');
    var index = from;
    digits.forEach(function (digit) {
      if (index < boxes.length) {
        boxes[index].value = digit;
        index += 1;
      }
    });
    boxes[Math.min(index, boxes.length - 1)].focus();
    submitIfFull();
  }

  boxes.forEach(function (box, index) {
    box.addEventListener('input', function () {
      var typed = box.value.replace(/\D/g, '');
      box.value = '';
      if (typed !== '') {
        // A phone's code suggestion can arrive all at once in one box
        fill(index, typed);
      }
    });

    box.addEventListener('keydown', function (event) {
      if (event.key === 'Backspace' && box.value === '' && index > 0) {
        event.preventDefault();
        boxes[index - 1].value = '';
        boxes[index - 1].focus();
      } else if (event.key === 'ArrowLeft' && index > 0) {
        event.preventDefault();
        boxes[index - 1].focus();
      } else if (event.key === 'ArrowRight' && index < boxes.length - 1) {
        event.preventDefault();
        boxes[index + 1].focus();
      }
    });

    box.addEventListener('paste', function (event) {
      var text = (event.clipboardData || window.clipboardData).getData('text') || '';
      if (/\d/.test(text)) {
        event.preventDefault();
        fill(index, text);
      }
    });

    box.addEventListener('focus', function () {
      box.select();
    });
  });

  form.addEventListener('submit', function () {
    sent = true;
  });

  // Resend code: greyed out with a countdown until a new code may be asked
  var resend = document.getElementById('otp-resend');
  var left = resend ? parseInt(resend.getAttribute('data-wait') || '0', 10) : 0;
  if (resend && left > 0) {
    var label = resend.textContent;
    resend.disabled = true;
    resend.textContent = label + ' (' + left + ')';
    var timer = window.setInterval(function () {
      left -= 1;
      if (left <= 0) {
        window.clearInterval(timer);
        resend.disabled = false;
        resend.textContent = label;
        return;
      }
      resend.textContent = label + ' (' + left + ')';
    }, 1000);
  }
})();
