const multer = require("multer");
const path = require("path");
const fs = require("fs");

// ✅ Konfigurasi Penyimpanan File
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = path.join(__dirname, "../uploads/profile_pictures/");

        // Buat folder jika belum ada
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        console.log("User in Multer:", req.user); // ✅ Debugging apakah req.user tersedia

        if (!req.user || !req.user.id) {
            return cb(new Error("User ID is required for filename"), false);
        }
        cb(null, `profile_${req.user.id}_${Date.now()}${path.extname(file.originalname)}`);
    },
});

// ✅ Middleware untuk Filter Format File
const fileFilter = (req, file, cb) => {
    console.log("Incoming File:", file); // ✅ Debugging
    
    const allowedTypes = ["image/jpeg", "image/png", "image/jpg"];
    if (!allowedTypes.includes(file.mimetype)) {
        console.log("⛔ Invalid MIME type:", file.mimetype);
        return cb(new Error("Only JPEG, PNG, and JPG are allowed"), false);
    }
    cb(null, true);
};

// ✅ Middleware Upload File
const upload = multer({
    storage,
    limits: { fileSize: 2 * 1024 * 1024 }, // Maksimum 2MB
    fileFilter,
}).single("profile_picture");

module.exports = { upload };
