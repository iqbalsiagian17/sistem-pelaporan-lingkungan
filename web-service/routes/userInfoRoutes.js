const express = require('express');
const userController = require('../controllers/user/userController');
const authMiddleware = require('../middleware/authMiddleware'); // ✅ Import middleware untuk otentikasi
const uploadService = require('../services/uploadProfileService'); // ✅ Import middleware upload


const router = express.Router();

// ✅ Buat atau tambahkan informasi user (POST)
router.post('/update', authMiddleware, userController.updateUserInfo);

// ✅ Ambil informasi user yang sedang login (GET)
router.get('/', authMiddleware, userController.getUserInfo);

// ✅ Perbarui informasi user (PUT)
router.put('/update', authMiddleware, userController.updateUserInfo);

router.put('/change-password', authMiddleware, userController.changePassword); 


router.put("/update-profile-picture", authMiddleware, (req, res, next) => {
    console.log("User Data:", req.user); // ✅ Debugging user
    next();
}, uploadService.upload, (req, res) => {
    console.log("Uploaded File:", req.file); // ✅ Debugging apakah file masuk
    userController.updateProfilePicture(req, res);
});

module.exports = router;
