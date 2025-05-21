const { Report, ReportAttachment, ReportStatusHistory, ReportEvidence, User, Notification,RatingReport, sequelize } = require('../../../models');
const { sendNotificationToUser } = require('../../../services/firebaseService');
const fs = require('fs');
const { Op } = require('sequelize');
const path = require('path');
const multer = require('multer');

// ✅ Setup multer untuk upload bukti
const evidenceStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/evidences/');
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1E9)}${ext}`;
    cb(null, uniqueName);
  }
});
const uploadEvidence = multer({ storage: evidenceStorage }).array('evidences', 5); // maksimal 5 bukti



// ✅ MELIHAT SEMUA LAPORAN (Admin Only)
exports.getAllReports = async (req, res) => {
  try {
    const reports = await Report.findAll({
      where: {
        status: { [Op.not]: 'draft' } // ⬅️ Tambahkan ini
      },
      include: [
        { model: ReportAttachment, as: 'attachments' },
        { model: User, as: 'user', attributes: ['id', 'username', 'email'] }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Jika tidak ada laporan, tetap kembalikan array kosong
    if (!reports || reports.length === 0) {
      return res.status(200).json({ message: "Tidak ada laporan yang tersedia", reports: [] });
    }

    res.status(200).json({ message: "Daftar laporan berhasil diambil", reports });
  } catch (error) {
    console.error("Error fetching reports:", error);
    res.status(500).json({ message: "Terjadi kesalahan server", error: error.message });
  }
};


// ✅ MELIHAT DETAIL LAPORAN (Admin Only)
exports.getReportById = async (req, res) => {
  try {
    const { id } = req.params;

    const report = await Report.findByPk(id, {
      include: [
        { model: ReportAttachment, as: 'attachments' },
        { model: ReportEvidence, as: 'evidences' }, 
        { model: ReportStatusHistory, as: 'statusHistory', include: { model: User, as: 'admin', attributes: ['id', 'username'] } },
        { model: User, as: 'user', attributes: ['id', 'username', 'email'] },
        { model: RatingReport, as: 'rating', attributes: ['id', 'rating', 'review', 'rated_at'] } // ✅ sesuai alias
      ]
    });

    if (!report) {
      return res.status(404).json({ message: 'Laporan tidak ditemukan' });
    }

    res.status(200).json({ message: 'Detail laporan berhasil diambil', report });
  } catch (error) {
    console.error('Error fetching report:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
};


// ✅ MENGHAPUS LAPORAN (Admin Only)
exports.deleteReport = async (req, res) => {
  try {
    const { id } = req.params;

    const report = await Report.findByPk(id, {
      include: { model: ReportAttachment, as: 'attachments' }
    });

    if (!report) {
      return res.status(404).json({ message: 'Laporan tidak ditemukan' });
    }

    // Hapus semua lampiran laporan
    for (const attachment of report.attachments) {
      try {
        fs.unlinkSync(attachment.file); // Hapus file dari server
      } catch (err) {
        console.error(`Gagal menghapus file ${attachment.file}:`, err.message);
      }
    }

    await sequelize.transaction(async (t) => {
      await ReportAttachment.destroy({ where: { report_id: id }, transaction: t });
      await ReportStatusHistory.destroy({ where: { report_id: id }, transaction: t }); // Hapus riwayat status laporan
      await report.destroy({ transaction: t });
    });

    res.status(200).json({ message: 'Laporan berhasil dihapus' });
  } catch (error) {
    console.error('Error deleting report:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
};


const getNotificationTitleByStatus = (status) => {
  switch (status) {
    case "pending":
      return "Laporan Sedang Diperiksa";
    case "verified":
      return "Laporan Telah Diverifikasi";
    case "in_progress":
      return "Laporan Sedang Ditindaklanjuti";
    case "completed":
      return "Laporan Telah Diselesaikan";
    case "rejected":
      return "Laporan Tidak Dapat Diproses";
    case "closed":
      return "Laporan Telah Ditutup";
    case "canceled":
      return "Laporan Telah Dibatalkan";
    case "reopened":
      return "Laporan Dibuka Kembali oleh Pengguna";
    default:
      return "Status Laporan Diperbarui";
  }
};

const generateNotificationMessage = (status, reportNumber) => {
  switch (status) {
    case "pending":
      return `Laporan Anda dengan nomor ${reportNumber} telah berhasil dikirim dan sedang diperiksa oleh tim Dinas Lingkungan Hidup Toba.`;
    case "verified":
      return `Laporan Anda dengan nomor ${reportNumber} telah diverifikasi dan dinyatakan valid. Selanjutnya akan ditindaklanjuti.`;
    case "in_progress":
      return `Laporan Anda dengan nomor ${reportNumber} sedang dalam proses penanganan oleh tim Dinas. Mohon tunggu informasi selanjutnya.`;
    case "completed":
      return `Laporan Anda dengan nomor ${reportNumber} telah ditangani dan dinyatakan selesai. Terima kasih atas kontribusinya.`;
    case "rejected":
      return `Mohon maaf, laporan Anda dengan nomor ${reportNumber} tidak dapat diproses karena tidak memenuhi kriteria yang ditetapkan.`;
    case "closed":
      return `Laporan Anda dengan nomor ${reportNumber} telah resmi ditutup. Terima kasih telah peduli terhadap lingkungan.`;
    case "canceled":
      return `Laporan Anda dengan nomor ${reportNumber} telah dibatalkan oleh tim Dinas. Terima kasih atas pengertiannya.`;   
    case "reopened":
      return `Laporan Anda dengan nomor ${reportNumber} telah dibuka kembali berdasarkan penilaian Anda sebelumnya. Tim akan menindaklanjuti kembali laporan ini.`;
    default:
      return `Laporan Anda dengan nomor ${reportNumber} mengalami pembaruan status. Silakan cek untuk informasi lengkap.`;
  }
};






exports.updateReportStatus = async (req, res) => {
  try {
    const admin_id = req.user.id;
    const { id } = req.params;
    const { new_status, message } = req.body;

    if (!new_status || !message) {
      return res.status(400).json({ message: 'Status baru dan pesan wajib diisi' });
    }

    // ✅ Validasi status yang diperbolehkan
    const allowedStatuses = [
      "pending", "verified", "in_progress", "completed",
      "rejected", "closed", "canceled", "reopened"
    ];
    if (!allowedStatuses.includes(new_status)) {
      return res.status(400).json({ message: "Status laporan tidak valid." });
    }

    const report = await Report.findByPk(id, {
      include: [
        { model: User, as: 'user', attributes: ['id', 'fcm_token'] }
      ]
    });

    if (!report) return res.status(404).json({ message: 'Laporan tidak ditemukan' });

    const previous_status = report.status;

    // ✅ Update status laporan
    report.status = new_status;
    await report.save();

    // ✅ Catat perubahan di histori
    await ReportStatusHistory.create({
      report_id: id,
      changed_by: admin_id,
      previous_status,
      new_status,
      message
    });

    // ✅ Jika completed dan ada file bukti
    if (new_status === "completed" && req.files) {
      if (req.files.length > 5) {
        return res.status(400).json({ message: 'Maksimal 5 gambar dapat diunggah sebagai bukti.' });
      }

      const evidences = req.files.map(file => ({
        report_id: id,
        file: `uploads/evidences/${file.filename}`,
        uploaded_by: admin_id
      }));

      await ReportEvidence.bulkCreate(evidences);
    }

    // ✅ Siapkan notifikasi
    const notifTitle = getNotificationTitleByStatus(new_status);
    const notifMessage = generateNotificationMessage(new_status, report.report_number);

    await Notification.create({
      user_id: report.user_id,
      report_id: report.id,
      title: notifTitle,
      message: notifMessage,
      type: "report",
      sent_by: "system",
      role_target: "user"
    });

    // ✅ Kirim FCM jika user punya token
    if (report.user.fcm_token) {
      await sendNotificationToUser(
        report.user.fcm_token,
        notifTitle,
        notifMessage,
        {
          report_id: report.id.toString(),
          type: "report_status_update",
          route: "notification"
        }
      );
    }

    // ✅ Log khusus jika laporan berasal dari reopened
    if (previous_status === 'reopened') {
      console.log(`✅ Admin ${admin_id} menindaklanjuti ulang laporan #${report.report_number} dari status 'reopened' ke '${new_status}'`);
    }

    // ✅ Kirim draft berikutnya jika laporan sekarang selesai
    const statusSelesai = ['closed', 'canceled', 'rejected'];
    if (statusSelesai.includes(new_status)) {
      const nextDraft = await Report.findOne({
        where: {
          user_id: report.user_id,
          status: 'draft'
        },
        order: [['createdAt', 'ASC']]
      });

      if (nextDraft) {
        const previousDraftStatus = nextDraft.status;
        nextDraft.status = 'pending';
        nextDraft.sent_at = new Date(); // Optional: jika kamu punya kolom sent_at
        await nextDraft.save();

        await ReportStatusHistory.create({
          report_id: nextDraft.id,
          changed_by: admin_id,
          previous_status: previousDraftStatus,
          new_status: 'pending',
          message: 'Laporan dikirim otomatis setelah laporan sebelumnya diselesaikan.'
        });

        await Notification.create({
          user_id: nextDraft.user_id,
          report_id: nextDraft.id,
          title: "Laporan Anda Telah Dikirim",
          message: `Laporan dengan judul "${nextDraft.title}" telah otomatis dikirim karena laporan sebelumnya telah selesai.`,
          type: "report",
          sent_by: "system",
          role_target: "user"
        });

        if (report.user.fcm_token) {
          await sendNotificationToUser(
            report.user.fcm_token,
            "Laporan Anda Telah Dikirim",
            `Laporan "${nextDraft.title}" telah otomatis dikirim.`,
            {
              report_id: nextDraft.id.toString(),
              type: "report_auto_sent",
              route: "notification"
            }
          );
        }

        console.log(`📤 Draft report #${nextDraft.report_number} otomatis dikirim.`);
      }
    }

    res.status(200).json({ message: 'Status laporan berhasil diperbarui' });

  } catch (error) {
    console.error("❌ Error updateReportStatus:", error);
    res.status(500).json({ message: "Terjadi kesalahan", error: error.message });
  }
};



// Auto-close laporan setelah 24 jam
exports.autoCloseCompletedReports = async () => {
  const { Report, ReportStatusHistory, Notification, User, sequelize } = require('../../../models');
  const { sendNotificationToUser } = require('../../../services/firebaseService');
  const { Op } = require('sequelize');
  const SYSTEM_USER_ID = 1; // Gunakan ID admin sistem default

  try {
    const batasWaktu = new Date(Date.now() - 48 * 60 * 60 * 1000); // 48 jam

    const reports = await Report.findAll({
      where: {
        status: 'completed',
        updatedAt: { [Op.lte]: batasWaktu },
        id: {
          [Op.notIn]: sequelize.literal(`(SELECT report_id FROM t_rating_report)`)
        }
      },
      include: [
        { model: User, as: 'user', attributes: ['id', 'fcm_token'] }
      ]
    });

    for (const report of reports) {
      const previous_status = report.status;
      const new_status = 'closed';

      // ✅ Update status
      report.status = new_status;
      await report.save();

      // ✅ Simpan ke riwayat status
      await ReportStatusHistory.create({
        report_id: report.id,
        changed_by: SYSTEM_USER_ID,
        previous_status,
        new_status,
        message: 'Laporan otomatis ditutup oleh sistem setelah 24 jam.'
      });

      // ✅ Siapkan notifikasi
      const notifTitle = getNotificationTitleByStatus(new_status);
      const notifMessage = generateNotificationMessage(new_status, report.report_number);

      await Notification.create({
        user_id: report.user_id,
        title: notifTitle,
        message: notifMessage,
        type: "report", // Konsisten seperti updateReportStatus
        sent_by: "system",
        role_target: "user"
      });

      // ✅ Kirim FCM jika ada token
      if (report.user?.fcm_token) {
        await sendNotificationToUser(
          report.user.fcm_token,
          notifTitle,
          notifMessage,
          {
            report_id: report.id.toString(),
            type: "report_status_update", // Konsisten seperti updateReportStatus
            route: "notification"
          }
        );
      }

      console.log(`✅ Report #${report.report_number} closed automatically.`);
    }
  } catch (err) {
    console.error("❌ Auto-close error:", err.message);
  }
};




