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
            { id: user.id, phone_number: user.phone_number, email: user.email, username: user.username, type: user.type, profile_picture: user.profile_picture },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );

        res.json({
            message: 'Login successful',
            user: { id: user.id, username: user.username, phone_number: user.phone_number, email: user.email, type: user.type, profile_picture: user.profile_picture },
            token // ✅ Kirim token ke client
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};


module.exports = { register, login  };
