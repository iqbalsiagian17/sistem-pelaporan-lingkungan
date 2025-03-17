const { ReportLikes, Report } = require('../../../models');

exports.likeReport = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { report_id } = req.params;

    // 🔹 Pastikan report_id adalah angka
    if (isNaN(report_id)) {
      return res.status(400).json({ message: "Invalid report ID" });
    }

    // 🔹 Cek apakah laporan ada
    const report = await Report.findByPk(report_id);
    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    // 🔹 Cek apakah user sudah like
    const existingLike = await ReportLikes.findOne({ where: { user_id, report_id } });
    if (existingLike) {
      return res.status(400).json({ message: "You have already liked this report" });
    }

    // 🔹 Tambahkan like ke `t_report_likes`
    await ReportLikes.create({ user_id, report_id });

    // 🔹 Pastikan kolom `likes` ada sebelum mengupdate
    if (report.likes !== undefined) {
      await report.increment('likes');
    }

    return res.status(201).json({ message: "Report liked successfully" });
  } catch (error) {
    console.error("❌ Error liking report:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.unlikeReport = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { report_id } = req.params;

    // 🔹 Pastikan report_id adalah angka
    if (isNaN(report_id)) {
      return res.status(400).json({ message: "Invalid report ID" });
    }

    // 🔹 Cek apakah user pernah like laporan ini
    const like = await ReportLikes.findOne({ where: { user_id, report_id } });
    if (!like) {
      return res.status(404).json({ message: "You haven't liked this report" });
    }

    // 🔹 Hapus like
    await like.destroy();

    // 🔹 Cek apakah laporan masih ada
    const report = await Report.findByPk(report_id);
    if (report && report.likes !== undefined) {
      await report.decrement('likes');
    }

    return res.status(200).json({ message: "Like removed successfully" });
  } catch (error) {
    console.error("❌ Error unliking report:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};

