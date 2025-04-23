const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 menit
  max: 5, // Maksimal 5 percobaan per identifier
  standardHeaders: true,
  legacyHeaders: false,

  // 🔐 Kunci limiter berdasarkan identifier (email/phone), bukan IP
  keyGenerator: (req, res) => {
    return req.body.identifier || req.ip;
  },

  // 📢 Pesan error yang lebih jelas
  message: (req, res) => ({
    message: `Terlalu banyak percobaan login untuk ${req.body.identifier || "akun ini"}. Silakan coba lagi dalam 15 menit.`,
  }),
});

module.exports = { loginLimiter };
