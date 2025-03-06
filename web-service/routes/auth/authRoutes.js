const express = require('express');
const authController = require('../../controllers/auth/authController');
const authMiddleware = require('../../middleware/authMiddleware'); 
const { loginLimiter } = require('../../middleware/rateLimiter'); // Import rate limiter

const router = express.Router();

router.post('/register', authController.register);
router.post('/login', loginLimiter,authController.login);
router.post('/logout', authController.logout);

//jangan gunakan di flutter
router.post('/refresh-token', authController.refreshToken);

module.exports = router;
