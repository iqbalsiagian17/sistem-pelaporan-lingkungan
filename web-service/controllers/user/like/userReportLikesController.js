const { UserReportLikeHistory, Report, User, Notification } = require('../../../models');
const { sendNotificationToUser } = require('../../../services/firebaseService');

exports.likeReport = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { report_id } = req.params;

    if (isNaN(report_id)) {
      return res.status(400).json({ message: "Invalid report ID" });
    }

    const report = await Report.findByPk(report_id, {
      include: { model: User, as: 'user' },
    });
    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    const existingLike = await UserReportLikeHistory.findOne({ where: { user_id, report_id } });
    if (existingLike) {
      return res.status(400).json({ message: "You have already liked this report" });
    }

    await UserReportLikeHistory.create({ user_id, report_id });

    if (report.total_likes !== undefined) {
      await report.increment('total_likes');
    }

    // 🔔 Kirim notifikasi jika user bukan pemilik laporan
    if (user_id !== report.user_id) {
      const liker = await User.findByPk(user_id);
      const targetUser = report.user;

      const notifTitle = `${liker.username}`;
      const notifMessage = `menyukai laporan Anda`;

      await Notification.create({
        user_id: targetUser.id,
        report_id: report.id,
        title: notifTitle,
        message: notifMessage,
        type: 'report',
        sent_by: 'system',
        role_target: 'user',
        is_read: false,
      });

      if (targetUser.fcm_token) {
        await sendNotificationToUser(
          targetUser.fcm_token,
          notifTitle,
          notifMessage,
          {
            type: "like",
            route: "notification",
            report_id: report.id.toString(),
          }
        );
      }
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

    if (isNaN(report_id)) {
      return res.status(400).json({ message: "Invalid report ID" });
    }

    const like = await UserReportLikeHistory.findOne({ where: { user_id, report_id } });
    if (!like) {
      return res.status(404).json({ message: "You haven't liked this report" });
    }

    await like.destroy();

    const report = await Report.findByPk(report_id, {
      include: { model: User, as: 'user' },
    });

    if (report && report.total_likes !== undefined) {
      await report.decrement('total_likes');

      // 🔻 Hapus notifikasi terkait like
      if (user_id !== report.user_id) {
        const liker = await User.findByPk(user_id);

        await Notification.destroy({
          where: {
            user_id: report.user.id,
            report_id: report.id,
            title: liker.username,
            message: 'menyukai laporan Anda',
            type: 'report',
          },
        });
      }
    }

    return res.status(200).json({ message: "Like removed successfully" });
  } catch (error) {
    console.error("❌ Error unliking report:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};
