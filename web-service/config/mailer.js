const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'baligebersih@gmail.com',
    pass: 'iviw yyhx geeo cxlb' // pakai App Password Gmail!
  }
});

module.exports = transporter;


