const express = require("express");
const router = express.Router();
const carouselController = require("../../controllers/admin/carousel/carouselController");
const authMiddleware = require("../../middleware/authMiddleware");
const isAdmin = require("../../middleware/adminMiddleware");
const multer = require("multer");
const fs = require("fs"); // ✅ Tambahkan ini
const path = require("path");
const extendTokenIfNeeded = require('../../middleware/extendTokenIfNeeded');


router.use(extendTokenIfNeeded); 

// ✅ Konfigurasi multer harus ada di sini juga
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = "uploads/carousel/";
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});
const upload = multer({ storage });

router.post("/", authMiddleware, isAdmin, upload.single("image"), carouselController.createCarousel);
router.get("/", carouselController.getAllCarousels); // Semua orang bisa melihat
router.get("/:id", authMiddleware, isAdmin, carouselController.getCarouselById);
router.put("/:id", authMiddleware, isAdmin, upload.single("image"), carouselController.updateCarousel);
router.delete("/:id", authMiddleware, isAdmin, carouselController.deleteCarousel);

module.exports = router;
