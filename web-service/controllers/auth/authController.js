const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userService = require('../../services/userService');
const { Notification } = require('../../models');


const register = async (req, res) => {
    try {
        const { phone_number,username, email, password } = req.body; // ✅ Gunakan phone_number, bukan username
        if (!phone_number || !email || !password) {
            return res.status(400).json({ message: "Phone number,usernmae, email, and password are required" });
        }

        // Hash password sebelum disimpan
        const hashedPassword = await bcrypt.hash(password, 10);

        // Simpan user baru dengan phone_number
        const newUser = await userService.createUser({ phone_number, username, email, password: hashedPassword, type: 0 });

        await Notification.create({
            user_id: newUser.id,
            title: "Pengguna Baru",
            message: `Akun ${newUser.username} telah mendaftar.`,
            type: "account",
            sent_by: "system",
            role_target: "admin"
          });

        res.status(201).json({ message: 'User registered successfully', user: newUser });
    } catch (error) {
        console.error("Register Error:", error);
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

const login = async (req, res) => {
    try {
        const { identifier, password, client } = req.body;

        if (!identifier || !password || !client) {
            return res.status(400).json({ message: "Identifier, password, and client type are required" });
        }

        const user = await userService.findByPhoneOrEmail(identifier);
        if (!user) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        if (user.blocked_until && new Date(user.blocked_until) > new Date()) {
            return res.status(403).json({
                message: `Your account is blocked until ${user.blocked_until}`
            });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        if (client === "react" && user.type !== 1) {
            return res.status(403).json({ message: "Access denied. Only admin accounts can login in React." });
        }

        if (client === "flutter" && user.type !== 0) {
            return res.status(403).json({ message: "Access denied. Only user accounts can login in Flutter." });
        }

        const accessToken = jwt.sign(
            {
                id: user.id,
                phone_number: user.phone_number,
                email: user.email,
                username: user.username,
                type: user.type,
            },
            process.env.JWT_SECRET,
            { 
                expiresIn: "15m" 
            }
        );

        const userData = {
            id: user.id,
            username: user.username,
            phone_number: user.phone_number,
            email: user.email,
            type: user.type,
            profile_picture: user.profile_picture
        };

        // ✅ Untuk React, cukup kirim access token saja
        if (client === "react") {
            return res.json({
                message: "Login successful",
                user: userData,
                token: accessToken
            });
        }

        // Untuk Flutter, sertakan juga refresh token
        const refreshToken = jwt.sign(
            { id: user.id },
            process.env.JWT_SECRET,
            { expiresIn: "7d" }
        );

        return res.json({
            message: "Login successful",
            user: userData,
            token: accessToken,
            refresh_token: refreshToken
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};






const logout = (req, res) => {
    if (req.cookies && req.cookies.refreshToken) {
        res.clearCookie("refreshToken");
    }
    res.status(200).json({ message: "Logout successful" });
};

//jangan gunakan di flutter
const refreshToken = (req, res) => {
    console.log("🟢 [DEBUG] Request Headers:", req.headers);
    console.log("🟢 [DEBUG] Request Body:", req.body);
    console.log("🟢 [DEBUG] Request Cookies:", req.cookies);

    let refreshToken;

    if (req.cookies && req.cookies.refreshToken) {
        refreshToken = req.cookies.refreshToken;  // React menggunakan cookies
    } else if (req.body && req.body.refresh_token) {
        refreshToken = req.body.refresh_token;  // Flutter menggunakan body request
    }

    if (!refreshToken) {
        console.log("❌ Tidak ada refresh token di request!");
        return res.status(401).json({ message: "No refresh token found" });
    }

    console.log("🔄 [DEBUG] Verifying refresh token:", refreshToken);

    jwt.verify(refreshToken, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log("❌ [DEBUG] Invalid refresh token!");
            return res.status(403).json({ message: "Invalid refresh token" });
        }

        const newAccessToken = jwt.sign(
            { id: decoded.id },
            process.env.JWT_SECRET,
            { expiresIn: "15m" }
        );

        console.log("✅ [DEBUG] Refresh token valid! Mengirim access token baru.");
        return res.json({ access_token: newAccessToken, refresh_token: refreshToken });
    });
};



module.exports = { register, login, logout, refreshToken }; 
