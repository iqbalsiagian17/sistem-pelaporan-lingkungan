require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');  // ✅ Tambahkan jika menggunakan cookies
const path = require("path");

// Import Routes
const authRoutes = require('./routes/auth/authRoutes');
const userInfoRoutes = require('./routes/user/userRoutes');
const userReportRoutes = require('./routes/user/reportRoutes');
const adminReportRoutes = require('./routes/admin/reportRoutes');
const adminCarouselRoutes = require("./routes/admin/carouselRoutes");
const adminAnnouncementRoutes = require("./routes/admin/announcementRoutes");
const forumRoutes = require("./routes/user/forumRoutes");
const userManagementRoutes = require("./routes/admin/userManagementRoutes");
const publicCarouselRoutes = require("./routes/public/carouselRoutes");
const publicAnnouncementRoutes = require("./routes/public/announcementRoutes");
const userReportSaveRoutes = require("./routes/user/userReportSaveRoutes");
const userReportLikesRoutes = require("./routes/user/userRoutesLikes");
const userPostLikesRoutes = require("./routes/user/userLikesPostRoutes");





// Inisialisasi Express
const app = express();
const PORT = process.env.PORT || 3000;

// 📌 Middleware
app.use(cors());
app.use(express.json());  // ✅ Middleware untuk membaca JSON
app.use(express.urlencoded({ extended: true }));  // ✅ Untuk mendukung form-data
app.use(bodyParser.json());  // ✅ Pastikan JSON bisa terbaca
app.use(cookieParser());  // ✅ Untuk membaca cookies jika ada

// 📌 Routes
// 🔹 Auth
app.use('/api/auth', authRoutes);

// 🔹 Public Routes
app.use("/api/carousels", publicCarouselRoutes);
app.use("/api/announcements", publicAnnouncementRoutes);


// 🔹 User Routes
app.use('/api/user/profile', userInfoRoutes); 
app.use('/api/user/reports', userReportRoutes); // CRUD laporan untuk user
app.use("/api/forum", forumRoutes);
app.use("/api/admin/users", userManagementRoutes);
app.use("/api/user/saved-reports", userReportSaveRoutes);
app.use("/api/user/reports", userReportLikesRoutes);
app.use("/api/user/post", userPostLikesRoutes);

// 🔹 Admin Routes
app.use('/api/admin/reports', adminReportRoutes);
app.use("/api/admin/carousels", adminCarouselRoutes);
app.use("/api/admin/announcements", adminAnnouncementRoutes);

// 🔹 Static Files
app.use("/uploads", express.static("uploads"));

// 📌 Start Server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
