const { Report, ReportAttachment, ReportStatusHistory, User, sequelize } = require('../../../models');
const fs = require('fs');

// ✅ MELIHAT SEMUA LAPORAN (Admin Only)
exports.getAllReports = async (req, res) => {
  try {
    const reports = await Report.findAll({
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
        { model: ReportStatusHistory, as: 'statusHistory', include: { model: User, as: 'admin', attributes: ['id', 'username'] } },
        { model: User, as: 'user', attributes: ['id', 'username', 'email'] }
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

exports.updateReportStatus = async (req, res) => {
  try {
    const admin_id = req.user.id; // Admin yang melakukan perubahan status
    const { id } = req.params;
    const { new_status, message } = req.body;

    if (!new_status || !message) {
      return res.status(400).json({ message: 'Status baru dan pesan wajib diisi' });
    }

    // Cek apakah user yang login adalah admin (type = 1)
    const adminUser = await User.findByPk(admin_id);
    if (!adminUser || adminUser.type !== 1) {
      return res.status(403).json({ message: 'Akses ditolak. Hanya admin yang bisa mengubah status laporan.' });
    }

    const report = await Report.findByPk(id);
    if (!report) {
      return res.status(404).json({ message: 'Laporan tidak ditemukan' });
    }

    if (report.status === new_status) {
      return res.status(400).json({ message: 'Laporan sudah berada dalam status ini' });
    }

    const previous_status = report.status;

    // Update status laporan
    report.status = new_status;
    await report.save();

    // Simpan riwayat perubahan status
    await ReportStatusHistory.create({
      report_id: id,
      changed_by: admin_id,
      previous_status,
      new_status,
      message
    });

    res.status(200).json({ message: 'Status laporan berhasil diperbarui' });

  } catch (error) {
    console.error('Error updating report status:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
};
