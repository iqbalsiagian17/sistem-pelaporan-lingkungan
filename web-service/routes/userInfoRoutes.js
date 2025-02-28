const express = require('express');
const userInfoController = require('../controllers/user/userInfoController');
const authMiddleware = require('../middleware/authMiddleware'); // Import middleware

const router = express.Router();

router.post('/', authMiddleware, userInfoController.createUserInfo);
router.get('/', authMiddleware, userInfoController.getUserInfo);
router.put('/', authMiddleware, userInfoController.updateUserInfo);
router.delete('/', authMiddleware, userInfoController.deleteUserInfo);

module.exports = router;
