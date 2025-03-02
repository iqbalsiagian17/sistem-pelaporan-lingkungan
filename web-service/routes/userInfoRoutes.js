const express = require('express');
const userInfoController = require('../controllers/user/userInfoController');
const authMiddleware = require('../middleware/authMiddleware'); // ✅ Import middleware untuk otentikasi
const uploadService = require('../services/uploadProfileService'); // ✅ Import middleware upload


const router = express.Router();

// ✅ Buat atau tambahkan informasi user (POST)
router.post('/create', authMiddleware, userInfoController.createUserInfo);

// ✅ Ambil informasi user yang sedang login (GET)
router.get('/', authMiddleware, userInfoController.getUserInfo);

// ✅ Perbarui informasi user (PUT)
router.put('/update', authMiddleware, userInfoController.updateUserInfo);

router.put('/update-profile-picture', authMiddleware, uploadService.upload, userInfoController.updateProfilePicture);

module.exports = router;
