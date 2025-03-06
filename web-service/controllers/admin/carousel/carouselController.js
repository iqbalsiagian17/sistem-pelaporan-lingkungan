const { Carousel } = require("../../../models");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Konfigurasi Multer untuk Upload Gambar
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
const upload = multer({ storage }).single("image");

// ✅ CREATE CAROUSEL (Admin Only)
exports.createCarousel = async (req, res) => {
    upload(req, res, async (err) => {
        if (err) {
            return res.status(400).json({ message: "File upload error", error: err.message });
        }

        try {
            const { title } = req.body;
            if (!title || !req.file) {
                return res.status(400).json({ message: "Title and image are required" });
            }

            const newCarousel = await Carousel.create({
                title,
                image: `uploads/carousel/${req.file.filename}`
            });

            res.status(201).json({ message: "Carousel created successfully", carousel: newCarousel });
        } catch (error) {
            console.error("Error creating carousel:", error);
            res.status(500).json({ message: "Server error", error: error.message });
        }
    });
};

// ✅ GET ALL CAROUSELS
exports.getAllCarousels = async (req, res) => {
    try {
        const carousels = await Carousel.findAll({ order: [["createdAt", "DESC"]] });
        res.status(200).json({ message: "Carousels retrieved successfully", carousels });
    } catch (error) {
        console.error("Error fetching carousels:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ GET CAROUSEL BY ID
exports.getCarouselById = async (req, res) => {
    try {
        const { id } = req.params;
        const carousel = await Carousel.findByPk(id);

        if (!carousel) {
            return res.status(404).json({ message: "Carousel not found" });
        }

        res.status(200).json({ message: "Carousel retrieved successfully", carousel });
    } catch (error) {
        console.error("Error fetching carousel:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ UPDATE CAROUSEL (Admin Only)
exports.updateCarousel = async (req, res) => {
    upload(req, res, async (err) => {
        if (err) {
            return res.status(400).json({ message: "File upload error", error: err.message });
        }

        try {
            const { id } = req.params;
            const { title } = req.body;

            const carousel = await Carousel.findByPk(id);
            if (!carousel) {
                return res.status(404).json({ message: "Carousel not found" });
            }

            if (req.file) {
                // Hapus gambar lama
                if (fs.existsSync(carousel.image)) {
                    fs.unlinkSync(carousel.image);
                }
                carousel.image = `uploads/carousel/${req.file.filename}`;
            }

            carousel.title = title || carousel.title;
            await carousel.save();

            res.status(200).json({ message: "Carousel updated successfully", carousel });
        } catch (error) {
            console.error("Error updating carousel:", error);
            res.status(500).json({ message: "Server error", error: error.message });
        }
    });
};

// ✅ DELETE CAROUSEL (Admin Only)
exports.deleteCarousel = async (req, res) => {
    try {
        const { id } = req.params;
        const carousel = await Carousel.findByPk(id);

        if (!carousel) {
            return res.status(404).json({ message: "Carousel not found" });
        }

        // Hapus file gambar dari server
        if (fs.existsSync(carousel.image)) {
            fs.unlinkSync(carousel.image);
        }

        await carousel.destroy();
        res.status(200).json({ message: "Carousel deleted successfully" });
    } catch (error) {
        console.error("Error deleting carousel:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};
