require('dotenv').config({
  path: process.env.NODE_ENV === 'production' ? '.env.production' : '.env'
});

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');  // ✅ Tambahkan jika menggunakan cookies
const path = require("path");
const cron = require('node-cron');


// Import Routes
const authRoutes = require('./routes/auth/authRoutes');
const userInfoRoutes = require('./routes/user/userRoutes');
const userReportRoutes = require('./routes/user/reportRoutes');
const adminReportRoutes = require('./routes/admin/reportRoutes');
const adminMediaCarouselRoutes = require("./routes/admin/mediaCarouselRoutes");
const adminAnnouncementRoutes = require("./routes/admin/announcementRoutes");
const adminParameterRoutes = require("./routes/admin/parameterRoutes");
const adminVillageRoutes = require("./routes/admin/villageRoutes");
const forumRoutes = require("./routes/user/forumRoutes");
const userManagementRoutes = require("./routes/admin/userManagementRoutes");
const publicMediaCarouselRoutes = require("./routes/public/mediaCarouselRoutes");
const publicAnnouncementRoutes = require("./routes/public/announcementRoutes");
const publicParameterRoutes = require("./routes/public/parameterRoutes")
const publicVillageRoutes = require("./routes/public/villageRoutes");
const userReportSaveRoutes = require("./routes/user/userReportSaveRoutes");
const userReportLikesRoutes = require("./routes/user/userRoutesLikes");
const userPostLikesRoutes = require("./routes/user/userLikesPostRoutes");
const adminForumRoutes = require("./routes/admin/forumRoutes");
const adminAnalyticsRoutes = require("./routes/admin/analyticsRoute")
const notificationRoutes = require("./routes/notification/notificationRoutes");
const deleteInactiveUsers = require('./scheduler/delete_inactive_users');
const { scheduleAutoCloseReports } = require('./scheduler/autoCloseScheduler');
require("./scheduler/campaignNotifier.js");
require("./scheduler/cleanupCampaignNotifications");




// Inisialisasi Express
const app = express();
const PORT = process.env.PORT || 3000;

// 📌 Middleware
app.use(cors());
app.use(express.json());  // ✅ Middleware untuk membaca JSON
app.use(express.urlencoded({ extended: true }));  // ✅ Untuk mendukung form-data
app.use(bodyParser.json());  // ✅ Pastikan JSON bisa terbaca
app.use(cookieParser());  // ✅ Untuk membaca cookies jika ada
scheduleAutoCloseReports();
deleteInactiveUsers(); // Menjalankan scheduler untuk menghapus user yang tidak aktif
// 📌 Routes

// 🔹 Auth
app.use('/api/auth', authRoutes);

// 🔹 Public Routes
app.use("/api/mediacarousels", publicMediaCarouselRoutes);
app.use("/api/announcements", publicAnnouncementRoutes);
app.use("/api/parameters", publicParameterRoutes);
app.use("/api/villages", publicVillageRoutes); // ✅ Tambahkan route desa

// 🔹 Nontification Routes
app.use("/api/notifications", notificationRoutes);

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
app.use("/api/admin/mediacarousels", adminMediaCarouselRoutes);
app.use("/api/admin/announcements", adminAnnouncementRoutes);
app.use("/api/admin/parameters", adminParameterRoutes);
app.use("/api/admin/post", adminForumRoutes);
app.use("/api/admin/analytics", adminAnalyticsRoutes);
app.use("/api/admin/villages", adminVillageRoutes);

// 🔹 Static Files
app.use("/uploads", express.static("uploads"));

// 📌 Start Server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
