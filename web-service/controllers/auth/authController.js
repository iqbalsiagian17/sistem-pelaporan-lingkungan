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

        const userData = {
            id: user.id,
            username: user.username,
            phone_number: user.phone_number,
            email: user.email,
            type: user.type,
            profile_picture: user.profile_picture
        };

        if (client === "react") {
            // **React menggunakan Refresh Token + HTTP-only cookies**
            const refreshToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: "7d" });

            // Simpan refresh token di HTTP-only cookie
            res.cookie('refreshToken', refreshToken, {
                httpOnly: true,
                secure: process.env.NODE_ENV === 'production',
                sameSite: 'Strict'
            });

            // Simpan access token di HTTP-only cookie
            res.cookie('accessToken', accessToken, {
                httpOnly: true,
                secure: process.env.NODE_ENV === 'production',
                sameSite: 'Strict'
            });

            return res.json({
                message: 'Login successful',
                user: userData,
                token: accessToken
            });
        } else if (client === "flutter") {
            // **Flutter hanya menerima access token dalam JSON response**
            return res.json({
                message: 'Login successful',
                user: userData,
                token: accessToken // ✅ Token dikirim dalam response
            });
        } else {
            return res.status(400).json({ message: "Invalid client type" });
        }
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};




const logout = (req, res) => {
    res.clearCookie('refreshToken');
    res.clearCookie('accessToken');
    res.status(200).json({ message: 'Logout successful' });
};

//jangan gunakan di flutter
const refreshToken = (req, res) => {
    const token = req.cookies.refreshToken;

    if (!token) {
        return res.status(401).json({ message: "No refresh token found" });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({ message: "Invalid refresh token" });
        }

        // Buat access token baru
        const newAccessToken = jwt.sign(
            { id: decoded.id },
            process.env.JWT_SECRET,
            { expiresIn: "15m" }
        );

        res.cookie('accessToken', newAccessToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'Strict'
        });

        res.json({ message: "Access token refreshed" });
    });
};




module.exports = { register, login, logout, refreshToken }; 
