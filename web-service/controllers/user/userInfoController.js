const userInfoService = require('../../services/userInfoService');
const userService = require('../../services/userService'); // ✅ Tambahkan userService untuk update User
const uploadService = require('../../services/uploadProfileService'); // ✅ Buat layanan untuk upload file
const { User, UserInfo } = require('../../models');
const fs = require("fs");
const path = require("path");


const createUserInfo = async (req, res) => {
    try {
        const { full_name, address, birth_date, gender, profile_picture, job } = req.body;
        const user_id = req.user.id; // Ambil user_id dari token JWT

        if (!full_name || !birth_date || !gender) {
            return res.status(400).json({ message: "Full Name, Birth Date, and Gender are required" });
        }

        const newUserInfo = await userInfoService.createUserInfo({
            user_id,
            full_name,
            address,
            birth_date,
            gender,
            profile_picture,
            job
        });

        res.status(201).json({ message: "UserInfo created successfully", data: newUserInfo });
    } catch (error) {
        console.error("Create UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const getUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id; // Ambil user_id dari token JWT

        // Ambil data user beserta UserInfo
        const user = await User.findOne({
            where: { id: user_id },
            attributes: ['username', 'phone_number', 'email'], // Hanya ambil field tertentu dari User
            include: [
                {
                    model: UserInfo,
                    as: 'UserInfo', // Sesuaikan dengan alias di asosiasi model
                    attributes: { exclude: ['createdAt', 'updatedAt'] } // Ambil semua kecuali timestamp
                }
            ]
        });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        res.json({
            message: "UserInfo retrieved successfully",
            data: {
                user: {
                    username: user.username,
                    phone_number: user.phone_number,
                    email: user.email
                },
                userInfo: user.UserInfo || null // Jika UserInfo tidak ditemukan, kembalikan null
            }
        });
    } catch (error) {
        console.error("Get UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const updateUserInfo = async (req, res) => {
    try {
        const user_id = req.user.id;
        const { username, email, phone_number, full_name, address, birth_date, gender, job } = req.body;

        // **Perbarui data User**
        await User.update(
            { username, email, phone_number },
            { where: { id: user_id } }
        );

        // **Perbarui atau buat UserInfo jika belum ada**
        const [userInfo, created] = await UserInfo.findOrCreate({
            where: { user_id },
            defaults: { full_name, address, birth_date, gender, job }
        });

        if (!created) {
            await userInfo.update({ full_name, address, birth_date, gender, job });
        }

        res.json({ message: "Profil berhasil diperbarui" });
    } catch (error) {
        console.error("Update UserInfo Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

const updateProfilePicture = async (req, res) => {
    try {
        const user_id = req.user.id;

        if (!req.file) {
            return res.status(400).json({ message: "File tidak ditemukan" });
        }

        // ✅ Dapatkan data user dari database
        const userInfo = await UserInfo.findOne({ where: { user_id } });

        if (!userInfo) {
            return res.status(404).json({ message: "User tidak ditemukan" });
        }

        // ✅ Path foto lama jika ada
        const oldProfilePicture = userInfo.profile_picture;

        // ✅ Path foto baru
        const profilePicturePath = `/uploads/profile_pictures/${req.file.filename}`;

        // ✅ Simpan foto baru ke database
        await UserInfo.update({ profile_picture: profilePicturePath }, { where: { user_id } });

        // ✅ Hapus foto lama hanya jika bukan default dan benar-benar ada
        if (oldProfilePicture && !oldProfilePicture.includes("default.png")) {
            const oldProfilePicturePath = path.join(__dirname, "../../uploads", oldProfilePicture.replace("/uploads/", ""));
            
            if (fs.existsSync(oldProfilePicturePath)) {
                fs.unlink(oldProfilePicturePath, (err) => {
                    if (err) {
                        console.error("❌ Gagal menghapus foto lama:", err);
                    } else {
                        console.log("✅ Foto lama berhasil dihapus:", oldProfilePicturePath);
                    }
                });
            } else {
                console.warn("⚠️ Foto lama tidak ditemukan atau sudah terhapus:", oldProfilePicturePath);
            }
        }

        // ✅ Kirim URL lengkap agar bisa diakses dari frontend
        const baseUrl = `${req.protocol}://${req.get("host")}/uploads`;
        const fullProfilePictureUrl = `${baseUrl}${profilePicturePath.replace("/uploads", "")}`;

        res.json({ message: "Foto profil berhasil diperbarui", profile_picture: fullProfilePictureUrl });

    } catch (error) {
        console.error("❌ Update Profile Picture Error:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};




module.exports = { createUserInfo, getUserInfo, updateUserInfo, updateProfilePicture };
