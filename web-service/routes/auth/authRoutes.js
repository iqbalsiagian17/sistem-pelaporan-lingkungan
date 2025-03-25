const express = require('express');
const authController = require('../../controllers/auth/authController');
const authMiddleware = require('../../middleware/authMiddleware'); 
const { loginLimiter } = require('../../middleware/rateLimiter'); // Import rate limiter
const { googleLogin } = require('../../controllers/auth/authGoogleController');


const router = express.Router();

router.post('/register', authController.register);
router.post('/login', loginLimiter,authController.login);
router.post('/logout', authController.logout);

router.post('/refresh-token', authController.refreshToken);

router.post('/google', googleLogin);

module.exports = router;
