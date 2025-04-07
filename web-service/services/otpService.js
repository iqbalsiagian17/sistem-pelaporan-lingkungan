const otpGenerator = require('otp-generator');
const transporter = require('../config/mailer');
const { t_otp } = require('../models'); // ✅ ambil dari index.js
const { Op } = require('sequelize');


// Fungsi untuk generate OTP angka saja
const generateNumericOtp = () => {
  return otpGenerator.generate(6, {
    digits: true,
    lowerCaseAlphabets: false,
    upperCaseAlphabets: false,
    specialChars: false,
  });
};


exports.sendOtp = async (email) => {
  const code = generateNumericOtp();
  const expiredAt = new Date(Date.now() + 5 * 60 * 1000); // 5 menit dari sekarang

  await t_otp.create({ user_email: email, code, expired_at: expiredAt });


  const htmlContent = `
    <div style="font-family: Arial, sans-serif; max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
      <h2 style="color: #1877f2;">Satu langkah lagi untuk mendaftar</h2>
      <p>Halo,</p>
      <p>Kami menerima permintaan Anda untuk membuat akun. Berikut kode konfirmasi Anda:</p>
      <div style="font-size: 24px; font-weight: bold; background-color: #f0f2f5; padding: 15px; text-align: center; letter-spacing: 3px; border-radius: 8px; margin: 20px 0;">
        ${code}
      </div>
      <p style="color: red;"><strong>Jangan bagikan kode ini kepada siapa pun.</strong></p>
      <p>Jika seseorang meminta kode ini, terutama jika mereka mengaku dari tim kami, <strong>jangan berikan!</strong></p>
      <p>Terima kasih,<br>Dinas Lingkungan Hidup Toba</p>
      <hr style="margin-top: 30px;">
      <p style="font-size: 12px; color: #888;">Pesan ini dikirim ke: ${email}</p>
    </div>
  `;

  await transporter.sendMail({
    from: '"Balige Bersih" <no-reply@baligebersih.id>', // Ganti Gmail
    to: email,
    subject: 'Kode OTP Anda - Balige Bersih',
    html: htmlContent
  });

  return true;
};


exports.verifyOtp = async (email, code) => {
  const otp = await t_otp.findOne({
    where: {
      user_email: email,
      code,
      is_used: false,
      expired_at: { [Op.gt]: new Date() }
    }
  });

  if (!otp) return false;

  otp.is_used = true;
  await otp.save();

  return true;
};

exports.refreshOtp = async (email) => {
  // Tandai semua OTP lama sebagai digunakan
  await t_otp.update(
    { is_used: true },
    {
      where: {
        user_email: email,
        is_used: false,
        expired_at: { [Op.gt]: new Date() }
      }
    }
  );

  // Generate OTP baru
  const code = generateNumericOtp();
  const expiredAt = new Date(Date.now() + 5 * 60 * 1000); // 5 menit dari sekarang

  await t_otp.create({ user_email: email, code, expired_at: expiredAt });



  // Kirim ke email
  const htmlContent = `
  <div style="font-family: Arial, sans-serif; max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
    <h2 style="color: #1877f2;">Kode OTP Baru</h2>
    <p>Halo,</p>
    <p>Kami mengirim ulang kode OTP sesuai permintaan Anda. Berikut kode baru Anda:</p>
    <div style="font-size: 24px; font-weight: bold; background-color: #f0f2f5; padding: 15px; text-align: center; letter-spacing: 3px; border-radius: 8px; margin: 20px 0;">
      ${code}
    </div>
    <p style="color: red;"><strong>Jangan bagikan kode ini kepada siapa pun.</strong></p>
    <p>Jika seseorang meminta kode ini, terutama jika mereka mengaku dari tim kami, <strong>jangan berikan!</strong></p>
    <p>Terima kasih,<br>Dinas Lingkungan Hidup Toba</p>
    <hr style="margin-top: 30px;">
    <p style="font-size: 12px; color: #888;">Pesan ini dikirim ke: ${email}</p>
  </div>
`;

await transporter.sendMail({
  from: '"Balige Bersih" <no-reply@baligebersih.id>', // Ganti Gmail
  to: email,
  subject: 'Kode OTP Baru - Balige Bersih',
  html: htmlContent
});

return true;
};