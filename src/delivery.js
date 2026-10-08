// Sends verification codes.
//
// EMAIL: sent through SMTP (see SMTP_* settings in .env.example) using nodemailer.
// PHONE: no SMS provider is connected yet.
//
// In development, when a channel isn't configured, the code is printed to the
// server console instead. In production a missing provider is an error.

const nodemailer = require('nodemailer');

let transporter = null;

function getTransporter() {
  if (transporter) return transporter;
  const { SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS } = process.env;
  if (!SMTP_HOST || !SMTP_USER || !SMTP_PASS) return null;

  const port = Number(SMTP_PORT) || 587;
  transporter = nodemailer.createTransport({
    host: SMTP_HOST,
    port,
    secure: port === 465, // 465 = implicit TLS, 587 = STARTTLS
    auth: { user: SMTP_USER, pass: SMTP_PASS },
    connectionTimeout: 10_000,
    greetingTimeout: 10_000,
    socketTimeout: 15_000,
  });
  return transporter;
}

function fromAddress() {
  return process.env.MAIL_FROM || `Nexify <${process.env.SMTP_USER}>`;
}

function buildEmail({ destination, code, expiresInMinutes = 10 }) {
  return {
    from: fromAddress(),
    to: destination,
    subject: `Your Nexify verification code: ${code}`,
    text:
      `Your Nexify verification code is ${code}.\n\n` +
      `It expires in ${expiresInMinutes} minutes. ` +
      `If you didn't try to sign up, you can ignore this email.`,
    html:
      `<div style="font-family:Arial,sans-serif;max-width:420px;margin:auto">` +
      `<h2 style="color:#16a34a">Nexify</h2>` +
      `<p>Your verification code is:</p>` +
      `<p style="font-size:32px;letter-spacing:6px;font-weight:bold">${code}</p>` +
      `<p>It expires in ${expiresInMinutes} minutes.</p>` +
      `<p style="color:#666;font-size:12px">If you didn't try to sign up, you can ignore this email.</p>` +
      `</div>`,
  };
}

let sender = async (message) => {
  const { method, destination, code } = message;
  const isProduction = process.env.NODE_ENV === 'production';

  if (method === 'EMAIL') {
    const mail = getTransporter();
    if (mail) {
      await mail.sendMail(buildEmail(message));
      return;
    }
    if (isProduction) throw new Error('SMTP is not configured.');
  } else if (isProduction) {
    throw new Error('No SMS provider is configured.');
  }

  console.log(`\n📨 [DEV] ${method} verification code for ${destination}: ${code}\n`);
};

async function sendVerificationCode(message) {
  await sender(message);
}

// Replace the whole delivery function (used by tests, or to plug in an SMS provider).
function setSender(fn) {
  sender = fn;
}

// Replace the SMTP transport (used by tests).
function setTransporter(t) {
  transporter = t;
}

module.exports = {
  sendVerificationCode,
  setSender,
  setTransporter,
  getTransporter,
  buildEmail,
};
