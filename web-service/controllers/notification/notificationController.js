const { Notification, User, Report, ReportStatusHistory } = require("../../models");
const { Op } = require("sequelize");

const NotificationController = {
  // Buat notifikasi (oleh sistem)
  async create(req, res) {
    try {
      const {
        user_id = null,
        title,
        message,
        type = "general",
        sent_by = "system",
        role_target = "user",
      } = req.body;

      if (!title || !message) {
        return res.status(400).json({ error: "Judul dan pesan wajib diisi." });
      }

      const notification = await Notification.create({
        user_id,
        title,
        message,
        type,
        sent_by,
        role_target,
      });

      return res.status(201).json({ notification });
    } catch (error) {
      console.error("Error create notification:", error);
      return res.status(500).json({ error: "Gagal membuat notifikasi." });
    }
  },

  // Ambil semua notifikasi (admin)
  async getAll(req, res) {
    try {
      const notifications = await Notification.findAll({
        include: [{ model: User, as: "user", attributes: ["id", "username", "email"] }],
        order: [["created_at", "DESC"]],
      });

      return res.json({ notifications });
    } catch (error) {
      console.error("Error getAll notifications:", error);
      return res.status(500).json({ error: "Gagal mengambil data notifikasi." });
    }
  },

  // Ambil notifikasi user tertentu
  async getByUser(req, res) {
    try {
      const userId = req.params.userId;

      const notifications = await Notification.findAll({
        where: { user_id: userId },
        order: [["created_at", "DESC"]],
      });

      return res.json({ notifications });
    } catch (error) {
      console.error("Error getByUser notifications:", error);
      return res.status(500).json({ error: "Gagal mengambil notifikasi user." });
    }
  },

  // Tandai notifikasi sudah dibaca
  async markAsRead(req, res) {
    try {
      const notificationId = req.params.id;

      const notification = await Notification.findByPk(notificationId);
      if (!notification) {
        return res.status(404).json({ error: "Notifikasi tidak ditemukan." });
      }

      await notification.update({ is_read: true });
      return res.json({ message: "Notifikasi ditandai sebagai dibaca." });
    } catch (error) {
      console.error("Error markAsRead:", error);
      return res.status(500).json({ error: "Gagal update status baca." });
    }
  },

  // Hapus notifikasi
  async delete(req, res) {
    try {
      const id = req.params.id;
      const notif = await Notification.findByPk(id);

      if (!notif) return res.status(404).json({ error: "Notifikasi tidak ditemukan." });

      await notif.destroy();
      return res.json({ message: "Notifikasi berhasil dihapus." });
    } catch (error) {
      console.error("Error delete notification:", error);
      return res.status(500).json({ error: "Gagal menghapus notifikasi." });
    }
  },

  // ✅ Notifikasi saat user mengirim laporan
  async notifyReportSubmitted(report) {
    try {
      await Notification.create({
        user_id: null,
        title: "Laporan Baru Masuk",
        message: `Laporan baru dari ${report.user?.username || 'pengguna'} dengan judul \"${report.title}\"`,
        type: "report",
        sent_by: "system",
        role_target: "admin",
      });
    } catch (err) {
      console.error("notifyReportSubmitted error:", err);
    }
  },

  // ✅ Notifikasi saat status laporan diubah oleh admin
  async notifyStatusChange(history) {
    try {
      const report = await Report.findByPk(history.report_id);
      if (!report) return;

      await Notification.create({
        user_id: report.user_id,
        title: "Status Laporan Diperbarui",
        message: `Status laporan Anda (\"${report.title}\") telah diubah dari ${history.previous_status} menjadi ${history.new_status}.`,
        type: "report_status",
        sent_by: history.changed_by,
        role_target: "user",
      });
    } catch (err) {
      console.error("notifyStatusChange error:", err);
    }
  },

  // ✅ Notifikasi saat user mendaftar
  async notifyUserRegistered(user) {
    try {
      await Notification.create({
        user_id: null,
        title: "Pengguna Baru Terdaftar",
        message: `Akun baru didaftarkan oleh ${user.username} (${user.email})`,
        type: "user",
        sent_by: "system",
        role_target: "admin",
      });
    } catch (err) {
      console.error("notifyUserRegistered error:", err);
    }
  }
};

module.exports = NotificationController;
