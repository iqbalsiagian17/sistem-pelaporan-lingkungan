const express = require("express");
const { getAllCarousels } = require("../../controllers/admin/carousel/carouselController");

const router = express.Router();

// 🔹 Route Public untuk mendapatkan carousel
router.get("/", getAllCarousels);

module.exports = router;
