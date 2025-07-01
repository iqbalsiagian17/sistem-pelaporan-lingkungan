const express = require('express');
const router = express.Router();
const villageController = require('../../controllers/admin/village/villageController');

// middleware auth dan isAdmin bisa kamu tambahkan
router.get('/', villageController.getAllVillages);
router.get('/:id', villageController.getVillageById);
router.post('/', villageController.createVillage);
router.put('/:id', villageController.updateVillage);
router.delete('/:id', villageController.deleteVillage);

module.exports = router;
