const { Notification, User, Report, ReportStatusHistory } = require("../../models");
const { Op } = require("sequelize");
const moment = require("moment-timezone"); // Pastikan sudah install: npm install moment-timezone

// ✅ Simpan FCM token user
const registerFcmToken = async (req, res) => {
  const { user_id, fcm_token } = req.body;

  if (!user_id || !fcm_token) {
    return res.status(400).json({ error: "user_id dan fcm_token wajib diisi." });
  }

  const user = await User.findByPk(user_id);
  if (!user) return res.status(404).json({ error: "User tidak ditemukan." });

  await user.update({ fcm_token });
  return res.json({ message: "Token FCM berhasil disimpan." });
};

// ✅ Tandai semua notifikasi sebagai dibaca
const markAllAsRead = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userType = req.user?.type; // 1 = admin, 0 = user biasa

    if (!userId && userType !== 1) {
      return res.status(401).json({ message: "Unauthorized: Tidak valid." });
    }

    if (userType === 1) {
      await Notification.update(
        { is_read: true },
        {
          where: {
            user_id: null,
            role_target: "admin",
          },
        }
      );
    } else {
      await Notification.update(
        { is_read: true },
        {
          where: {
            user_id: userId,
            role_target: "user",
          },
        }
      );
    }

    return res.json({ message: "Semua notifikasi berhasil ditandai sebagai dibaca." });
  } catch (err) {
    console.error("❌ markAllAsRead error:", err);
    return res.status(500).json({ message: "Gagal menandai semua notifikasi.", error: err.message });
  }
};

// ✅ Ambil semua notifikasi (admin)
const getAll = async (req, res) => {
  try {
    const notifications = await Notification.findAll({
      include: [{ model: User, as: "user", attributes: ["id", "username", "email"] }],
      order: [["createdAt", "DESC"]],
    });

    const converted = notifications.map((notif) => {
      const json = notif.toJSON();
      json.createdAt = moment(json.createdAt).tz("Asia/Jakarta").format();
      json.updatedAt = moment(json.updatedAt).tz("Asia/Jakarta").format();
      return json;
    });

    return res.json({ notifications: converted });
  } catch (error) {
    console.error("Error getAll notifications:", error);
    return res.status(500).json({ error: "Gagal mengambil data notifikasi." });
  }
};

// ✅ Ambil notifikasi user tertentu (WIB)
const getByUser = async (req, res) => {
  try {
    const userId = req.params.userId;

    const notifications = await Notification.findAll({
      where: { user_id: userId },
      order: [["createdAt", "DESC"]],
    });

    const converted = notifications.map((notif) => {
      const json = notif.toJSON();
      json.createdAt = moment(json.createdAt).tz("Asia/Jakarta").format(); // → +07:00
      json.updatedAt = moment(json.updatedAt).tz("Asia/Jakarta").format();
      return json;
    });

    return res.json({ notifications: converted });
  } catch (error) {
    console.error("Error getByUser notifications:", error);
    return res.status(500).json({ error: "Gagal mengambil notifikasi user." });
  }
};

// ✅ Tandai notifikasi sebagai dibaca
const markAsRead = async (req, res) => {
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
};

// ✅ Hapus notifikasi
const deleteNotif = async (req, res) => {
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
};

module.exports = {
  registerFcmToken,
  markAllAsRead,
  getAll,
  getByUser,
  markAsRead,
  delete: deleteNotif,
};
