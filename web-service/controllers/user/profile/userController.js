const userService = require('../../../services/userService'); // ✅ Tambahkan userService untuk update User
const fs = require("fs");
const path = require("path");


const getUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // ID dari token JWT

        // ✅ Ambil data user langsung dari tabel `User`
        const user = await userService.getUserById(user_id);

        if (!user) {
            return res.status(404).json({ message: "User tidak ditemukan" });
        }

        res.json({
            message: "User berhasil diambil",
            data: user
        });
    } catch (error) {
        console.error("❌ Get User Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ Perbarui informasi user yang sedang login
const updateUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // Get user ID from JWT token
        const { username, email, phone_number } = req.body;

        // ✅ Check if at least one field is provided
        if (!username && !email && !phone_number) {
            return res.status(400).json({ message: "At least one field (username, email, or phone number) must be provided" });
        }

        // ✅ Create an object with only the fields that are present in the request
        const updateData = {};
        if (username) updateData.username = username;
        if (email) updateData.email = email;
        if (phone_number) updateData.phone_number = phone_number;

        // ✅ Update user data
        const updatedUser = await userService.updateUser(user_id, updateData);

        if (!updatedUser) {
            return res.status(404).json({ message: "User not found or no changes made" });
        }

        res.json({ message: "User information updated successfully", data: updatedUser });
    } catch (error) {
        console.error("❌ Update User Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
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



module.exports = { getUserInfo, updateUserInfo, changePassword };
