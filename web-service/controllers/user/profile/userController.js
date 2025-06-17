const userService = require('../../../services/userService');
const fs = require("fs");
const path = require("path");
const multer = require("multer");

// 🔧 Setup storage untuk upload foto profil
const profilePicStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = "uploads/profile/";
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const uploadProfilePic = multer({ storage: profilePicStorage }).single("profile_picture");

const getUserInfo = async (req, res) => {
  try {
    const user_id = req.user.id;
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

const updateUserInfo = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { username, email, phone_number } = req.body;

    if (!username && !email && !phone_number) {
      return res.status(400).json({ message: "Minimal satu field (username, email, phone number) harus diisi" });
    }

    const updateData = {};
    if (username) updateData.username = username;
    if (email) updateData.email = email;
    if (phone_number) updateData.phone_number = phone_number;

    const updatedUser = await userService.updateUser(user_id, updateData);

    if (!updatedUser) {
      return res.status(404).json({ message: "User tidak ditemukan atau tidak ada perubahan" });
    }

    res.json({ message: "Informasi user berhasil diperbarui", data: updatedUser });
  } catch (error) {
    console.error("❌ Update User Error:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const changePassword = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { oldPassword, newPassword } = req.body;

    if (!oldPassword || !newPassword) {
      return res.status(400).json({ message: "Password lama dan baru harus diisi" });
    }

    await userService.changePassword(user_id, oldPassword, newPassword);

    res.json({ message: "Password berhasil diubah" });
  } catch (error) {
    console.error("Change Password Error:", error);
    res.status(400).json({ message: error.message });
  }
};

const updateProfilePicture = (req, res) => {
  uploadProfilePic(req, res, async (err) => {
    try {
      if (err) {
        return res.status(400).json({ message: "Upload gagal", error: err.message });
      }

      const user_id = req.user.id;

      if (!req.file) {
        return res.status(400).json({ message: "File tidak ditemukan" });
      }

      const imagePath = req.file.path.replace(/\\/g, '/');

      // ✅ Ambil data user lama
      const oldUser = await userService.getUserById(user_id);

      // ✅ Hapus file lama jika ada
      if (oldUser?.profile_picture) {
      const oldPath = path.resolve('uploads/profile', path.basename(oldUser.profile_picture));
        if (fs.existsSync(oldPath)) {
          fs.unlinkSync(oldPath);
        }
      }

      // ✅ Simpan path baru ke DB
      const updatedUser = await userService.updateUser(user_id, {
        profile_picture: imagePath,
      });

      res.json({
        message: "Foto profil berhasil diperbarui",
        data: updatedUser,
      });
    } catch (error) {
      console.error("❌ Update Profile Picture Error:", error);
      res.status(500).json({ message: "Server error", error: error.message });
    }
  });
};

module.exports = {
  getUserInfo,
  updateUserInfo,
  changePassword,
  updateProfilePicture
};
