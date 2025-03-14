const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userService = require('../../services/userService');

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
            return res.status(400).json({ message: "Phone number/email, password, and client type are required" });
        }

        const user = await userService.findByPhoneOrEmail(identifier);
        if (!user) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        // **Cek apakah user sedang diblokir**
        if (user.blocked_until && new Date(user.blocked_until) > new Date()) {
            return res.status(403).json({
                message: `Your account is blocked until ${user.blocked_until}`
            });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        // **Validasi akun berdasarkan `client`**
        if (client === "react" && user.type !== 1) {
            return res.status(403).json({ message: "Access denied. Only admin accounts can login in React." });
        }

        if (client === "flutter" && user.type !== 0) {
            return res.status(403).json({ message: "Access denied. Only user accounts can login in Flutter." });
        }

        // **Buat access token**
        const accessToken = jwt.sign(
            { id: user.id, phone_number: user.phone_number, email: user.email, username: user.username, type: user.type, profile_picture: user.profile_picture },
            process.env.JWT_SECRET,
            { expiresIn: "15m" } // **Access Token hanya berlaku 15 menit**
        );

        const refreshToken = jwt.sign(
            { id: user.id },
            process.env.JWT_SECRET,
            { expiresIn: "7d" } // ✅ Refresh Token berlaku 7 hari
        );

        const userData = {
            id: user.id,
            username: user.username,
            phone_number: user.phone_number,
            email: user.email,
            type: user.type,
            profile_picture: user.profile_picture
        };

        // **React & Flutter sama-sama menerima token dalam JSON response**
        if (client === "react") {
            res.cookie("refreshToken", refreshToken, {
                httpOnly: true,
                secure: process.env.NODE_ENV === "production",
                sameSite: "Strict",
                maxAge: 7 * 24 * 60 * 60 * 1000, // 7 hari
            });
            return res.json({ message: "Login successful", user, token: accessToken });
        } else {
            return res.json({ message: "Login successful", user, token: accessToken, refresh_token: refreshToken });
        }
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
