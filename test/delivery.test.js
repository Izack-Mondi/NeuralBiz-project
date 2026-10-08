const { test } = require('node:test');
const assert = require('node:assert/strict');
const nodemailer = require('nodemailer');

const delivery = require('../src/delivery');

test('EMAIL codes are sent through the SMTP transport', async () => {
  process.env.SMTP_USER = 'noreply@example.com';
  delivery.setTransporter(nodemailer.createTransport({ jsonTransport: true }));

  const sent = [];
  const real = delivery.getTransporter();
  const originalSend = real.sendMail.bind(real);
  real.sendMail = async (m) => {
    const info = await originalSend(m);
    sent.push(JSON.parse(info.message));
    return info;
  };

  await delivery.sendVerificationCode({
    method: 'EMAIL',
    destination: 'henry@example.com',
    code: '482913',
    expiresInMinutes: 10,
  });

  assert.equal(sent.length, 1);
  assert.equal(sent[0].to[0].address, 'henry@example.com');
  assert.match(sent[0].subject, /482913/);
  assert.match(sent[0].text, /expires in 10 minutes/);
  assert.match(sent[0].from.address, /noreply@example.com/);
});
