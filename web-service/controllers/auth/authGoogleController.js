const { OAuth2Client } = require('google-auth-library');
const jwt = require('jsonwebtoken');
const userService = require('../../services/userService');

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const googleLogin = async (req, res) => {
  const { email, username, idToken, client: clientType } = req.body;

  if (!email || !idToken || !clientType) {
    console.log("❌ Missing required fields:", req.body);
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    console.log("🔹 Menerima Google Login Request");
    console.log("🔹 Email:", email);
    console.log("🔹 ID Token:", idToken.substring(0, 10) + "... (dipotong untuk keamanan)");

    // Verifikasi token dari Google
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    console.log("✅ Token berhasil diverifikasi:", payload);

    if (!payload || !payload.email) {
      console.log("❌ Payload tidak valid!");
      return res.status(401).json({ message: 'Invalid Google token' });
    }

    console.log("🔹 Token Audience:", payload.aud);
    console.log("🔹 Expected Audience (GOOGLE_CLIENT_ID):", process.env.GOOGLE_CLIENT_ID);

    if (payload.aud !== process.env.GOOGLE_CLIENT_ID) {
      console.log("❌ Audience mismatch!");
      return res.status(401).json({ message: "Invalid token audience" });
    }

    if (payload.email !== email) {
      console.log("❌ Email mismatch! Expected:", payload.email, "Received:", email);
      return res.status(401).json({ message: 'Email mismatch' });
    }

    // Gunakan findByEmail yang baru ditambahkan
    let user = await userService.findByEmail(email);

    // Jika belum ada, buat akun baru
    if (!user) {
      console.log("🔹 User tidak ditemukan, membuat akun baru...");
      user = await userService.createUser({
        username: username || email.split('@')[0],
        email,
        phone_number: null,
        password: null, // Tidak ada password
        type: 0, // Default user Flutter
        auth_provider: 'google',
      });
    } else {
      console.log("✅ User ditemukan:", user.email);
    }

    // Validasi akses
    if (clientType === 'react' && user.type !== 1) {
      return res.status(403).json({ message: "Access denied. Only admin accounts can login in React." });
    }

    if (clientType === 'flutter' && user.type !== 0) {
      return res.status(403).json({ message: "Access denied. Only user accounts can login in Flutter." });
    }

    // Buat access token & refresh token
    const accessToken = jwt.sign(
      { id: user.id, email: user.email, username: user.username, type: user.type },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );

    const refreshToken = jwt.sign(
      { id: user.id },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    console.log("✅ Login Google berhasil, mengembalikan token ke frontend");
    res.json({
      message: 'Login Google success',
      user,
      token: accessToken,
      refresh_token: refreshToken,
    });

  } catch (error) {
    console.error('❌ Google login error:', error);
    res.status(500).json({ message: 'Google login failed', error: error.message });
  }
};

module.exports = { googleLogin };
