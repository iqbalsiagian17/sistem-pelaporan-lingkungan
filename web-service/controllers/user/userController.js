const userService = require('../../services/userService'); // ✅ Tambahkan userService untuk update User
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
        const user_id = req.user.id; // ID dari token JWT
        const { username, email, phone_number } = req.body;

        if (!username || !email || !phone_number) {
            return res.status(400).json({ message: "Username, Email, dan Nomor Telepon wajib diisi" });
        }

        // ✅ Perbarui data user
        const response = await userService.updateUser(user_id, { username, email, phone_number });

        res.json(response);
    } catch (error) {
        console.error("❌ Update User Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};


const updateProfilePicture = async (req, res) => {
    try {
        const user_id = req.user.id;

        if (!req.file) {
            return res.status(400).json({ message: "File tidak ditemukan" });
        }

        // ✅ Ambil data user
        const user = await userService.getUserById(user_id);
        if (!user) {
            return res.status(404).json({ message: "User tidak ditemukan" });
        }

        // ✅ Path foto lama jika ada
        const oldProfilePicture = user.profile_picture;
        const newProfilePicturePath = `/uploads/profile_pictures/${req.file.filename}`;

        // ✅ Update database
        await userService.updateUser(user_id, { profile_picture: newProfilePicturePath });

        // ✅ Hapus foto lama (jika bukan default)
        if (oldProfilePicture && !oldProfilePicture.includes("default.png")) {
            const oldProfilePicturePath = path.join(__dirname, "../../uploads/profile_pictures", path.basename(oldProfilePicture));

            if (fs.existsSync(oldProfilePicturePath)) {
                try {
                    fs.unlinkSync(oldProfilePicturePath);
                    console.log("✅ Foto lama berhasil dihapus:", oldProfilePicturePath);
                } catch (err) {
                    console.error("❌ Gagal menghapus foto lama:", err);
                }
            } else {
                console.warn("⚠️ Foto lama tidak ditemukan atau sudah terhapus:", oldProfilePicturePath);
            }
        }

        // ✅ Kirim URL foto baru
        const baseUrl = `${req.protocol}://${req.get("host")}`;
        const fullProfilePictureUrl = `${baseUrl}${newProfilePicturePath}`;

        res.json({ message: "Foto profil berhasil diperbarui", profile_picture: fullProfilePictureUrl });

    } catch (error) {
        console.error("❌ Update Profile Picture Error:", error);
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



module.exports = { getUserInfo, updateUserInfo, updateProfilePicture, changePassword };
