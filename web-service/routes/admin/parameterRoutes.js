const express = require('express');
const router = express.Router();
const parameterController = require('../../controllers/admin/parameter/parameterController');
const authMiddleware = require('../../middleware/authMiddleware');
const isAdmin = require('../../middleware/adminMiddleware');
const upload = require('../../middleware/uploadVideo');

// ✅ Create + upload landing_video
router.post('/', authMiddleware, isAdmin, upload.single('landing_video'), parameterController.createParameter);

// ✅ Update + upload landing_video
router.put('/:id', authMiddleware, isAdmin, upload.single('landing_video'), parameterController.updateParameter);

// ✅ Get & Delete
router.get('/', authMiddleware, isAdmin, parameterController.getAllParameter);
router.delete('/:id', authMiddleware, isAdmin, parameterController.deleteParameter);

module.exports = router;
