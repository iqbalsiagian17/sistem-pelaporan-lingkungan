const express = require("express");
const router = express.Router();
const carouselController = require("../../controllers/admin/carousel/carouselController");
const authMiddleware = require("../../middleware/authMiddleware");
const isAdmin = require("../../middleware/adminMiddleware"); 

// Hanya Admin yang bisa mengelola carousel
router.post("/", authMiddleware, isAdmin, carouselController.createCarousel);
router.get("/", authMiddleware, isAdmin, carouselController.getAllCarousels); // Semua orang bisa melihat
router.get("/:id", authMiddleware, isAdmin, carouselController.getCarouselById); 
router.put("/:id", authMiddleware, isAdmin, carouselController.updateCarousel);
router.delete("/:id", authMiddleware, isAdmin, carouselController.deleteCarousel);

module.exports = router;
