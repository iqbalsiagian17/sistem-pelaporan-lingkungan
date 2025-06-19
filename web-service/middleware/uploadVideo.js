const multer = require("multer");
const path = require("path");

// Lokasi penyimpanan video
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/videos/parameter/");
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const uniqueName = `landing-${Date.now()}${ext}`;
    cb(null, uniqueName);
  },
});

const upload = multer({
  storage,
  fileFilter: (req, file, cb) => {
    const allowedTypes = [".mp4", ".webm", ".ogg"];
    const ext = path.extname(file.originalname).toLowerCase();
    if (!allowedTypes.includes(ext)) {
      return cb(new Error("Hanya file video (.mp4/.webm/.ogg) yang diperbolehkan"), false);
    }
    cb(null, true);
  },
});

module.exports = upload;
