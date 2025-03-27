const express = require("express");
const router = express.Router();
const NotificationController = require("../../controllers/notification/NotificationController");

// ✅ Buat notifikasi manual (opsional, untuk admin)
router.post("/", NotificationController.create);

// ✅ Ambil semua notifikasi (untuk admin)
router.get("/", NotificationController.getAll);

// ✅ Ambil notifikasi milik user tertentu
router.get("/user/:userId", NotificationController.getByUser);

// ✅ Tandai notifikasi sebagai dibaca
router.put("/read/:id", NotificationController.markAsRead);

// ✅ Hapus notifikasi
router.delete("/:id", NotificationController.delete);

// ✅ [OTOMATIS] Notifikasi: laporan baru dari user
router.post("/trigger/report-submitted", NotificationController.notifyReportSubmitted);

// ✅ [OTOMATIS] Notifikasi: perubahan status laporan
router.post("/trigger/status-changed", NotificationController.notifyStatusChange);

// ✅ [OTOMATIS] Notifikasi: user baru mendaftar
router.post("/trigger/user-registered", NotificationController.notifyUserRegistered);

module.exports = router;
