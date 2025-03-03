const express = require('express');
const authController = require('../controllers/auth/authController');
const authMiddleware = require('../middleware/authMiddleware'); 

const router = express.Router();

router.post('/register', authController.register);
router.post('/login', authController.login);

module.exports = router;
