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
        const { identifier, password } = req.body;

        if (!identifier || !password) {
            return res.status(400).json({ message: "Phone number/email and password are required" });
        }

        const user = await userService.findByPhoneOrEmail(identifier);
        if (!user) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid phone number/email or password' });
        }

        const token = jwt.sign(
            { id: user.id, phone_number: user.phone_number, email: user.email, type: user.type },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );

        res.json({
            message: 'Login successful',
            user: { id: user.id, phone_number: user.phone_number, email: user.email, type: user.type },
            token // ✅ Kirim token ke client
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};




const logout = (req, res) => {
    res.json({ message: 'Logout successful, please remove the token on the client side' });
};


const changePassword = async (req, res) => {
    try {
        const user_id = req.user.id; // Ambil user_id dari token JWT
        const { oldPassword, newPassword } = req.body;

        if (!oldPassword || !newPassword) {
            return res.status(400).json({ message: "Old password and new password are required" });
        }

        // Panggil service untuk mengganti password
        await userService.changePassword(user_id, oldPassword, newPassword);

        res.json({ message: "Password changed successfully" });
    } catch (error) {
        console.error("Change Password Error:", error);
        res.status(400).json({ message: error.message });
    }
};

module.exports = { register, login, logout,changePassword };
