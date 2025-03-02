const multer = require("multer");
const path = require("path");
const fs = require("fs");

// ✅ Konfigurasi Penyimpanan File
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = path.join(__dirname, "../uploads/profile_pictures/");
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, `profile_${req.user.id}_${Date.now()}${path.extname(file.originalname)}`);
    },
});

// ✅ Middleware untuk Filter Format File
const fileFilter = (req, file, cb) => {
    console.log("File Uploaded:", file); // ✅ Debugging

    const allowedTypes = ["image/jpeg", "image/png", "image/jpg"];

    if (!allowedTypes.includes(file.mimetype)) {
        console.log("⛔ MIME type tidak dikenali:", file.mimetype); // ✅ Tambahkan log
        return cb(new Error("Hanya format JPEG, PNG, dan JPG yang diperbolehkan"), false);
    }
    cb(null, true);
};

// ✅ Middleware Upload File
const upload = multer({
    storage,
    limits: { fileSize: 2 * 1024 * 1024 }, // Maksimum 2MB
    fileFilter,
}).single("profile_picture");

const uploadImage = async (file) => {
    return `/uploads/profile_pictures/${file.filename}`; // ✅ Simpan URL gambar
};

module.exports = { upload, uploadImage };
