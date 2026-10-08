// Checks your SMTP settings and sends a test email.
//   node scripts/test-email.js you@example.com
require('dotenv').config();
const { getTransporter, buildEmail } = require('../src/delivery');

async function main() {
  const to = process.argv[2];
  if (!to) {
    console.error('Usage: node scripts/test-email.js <your-email>');
    process.exit(1);
  }
  const mail = getTransporter();
  if (!mail) {
    console.error('SMTP is not configured. Set SMTP_HOST, SMTP_USER and SMTP_PASS in .env');
    process.exit(1);
  }
  await mail.verify();
  console.log('✅ SMTP login works.');
  await mail.sendMail(buildEmail({ destination: to, code: '123456' }));
  console.log(`✅ Test email sent to ${to}. Check your inbox (and spam).`);
}

main().catch((err) => {
  console.error('❌ Failed:', err.message);
  process.exit(1);
});
