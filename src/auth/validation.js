const { badInput } = require('../errors');

function normalizeName(raw) {
  const name = String(raw ?? '').trim().replace(/\s+/g, ' ');
  if (name.length < 2 || name.length > 100) {
    throw badInput('Please enter your full name (2 to 100 characters).');
  }
  return name;
}

function normalizeEmail(raw) {
  const email = String(raw ?? '').trim().toLowerCase();
  if (email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
    throw badInput('Please enter a valid email address.');
  }
  return email;
}

// Returns E.164 (+254...) or null when empty. Local Kenyan formats
// (07xx..., 01xx..., 2547xx...) are accepted.
function normalizePhone(raw) {
  if (raw == null) return null;
  const text = String(raw).trim();
  if (!text) return null;
  const hasPlus = text.startsWith('+');
  let digits = text.replace(/\D/g, '');
  if (!digits) return null;
  if (!hasPlus) {
    if (digits.startsWith('0')) digits = '254' + digits.slice(1);
    else if (!digits.startsWith('254') && digits.length === 9) digits = '254' + digits;
  }
  const phone = '+' + digits;
  if (!/^\+[1-9]\d{7,14}$/.test(phone)) {
    throw badInput('Please enter a valid phone number.');
  }
  return phone;
}

// Mirrors the rules on the Flutter create-password screen.
function validatePassword(raw) {
  const password = String(raw ?? '');
  if (Buffer.byteLength(password) > 72) {
    throw badInput('Password is too long (72 characters maximum).');
  }
  const missing = [];
  if (password.length < 8) missing.push('at least 8 characters');
  if (!/[A-Z]/.test(password)) missing.push('an uppercase letter');
  if (!/[0-9]/.test(password)) missing.push('a number');
  if (!/[^A-Za-z0-9]/.test(password)) missing.push('a symbol');
  if (missing.length) {
    throw badInput(`Password needs ${missing.join(', ')}.`);
  }
  return password;
}

function cleanOptionalText(raw, max = 100) {
  if (raw == null) return null;
  const text = String(raw).trim();
  if (!text) return null;
  if (text.length > max) throw badInput(`Text is too long (maximum ${max} characters).`);
  return text;
}

function cleanInterests(raw) {
  if (raw == null) return [];
  const seen = new Set();
  const out = [];
  for (const item of raw) {
    const value = String(item).trim();
    if (!value) continue;
    if (value.length > 50) throw badInput('An interest is too long (maximum 50 characters).');
    const key = value.toLowerCase();
    if (!seen.has(key)) {
      seen.add(key);
      out.push(value);
    }
  }
  if (out.length > 20) throw badInput('Please choose at most 20 interests.');
  return out;
}

module.exports = {
  normalizeName,
  normalizeEmail,
  normalizePhone,
  validatePassword,
  cleanOptionalText,
  cleanInterests,
};
