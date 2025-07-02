const express = require('express');
const router = express.Router();
const villageController = require('../../controllers/admin/village/villageController');

router.get('/', villageController.getAllVillages);

module.exports = router;
