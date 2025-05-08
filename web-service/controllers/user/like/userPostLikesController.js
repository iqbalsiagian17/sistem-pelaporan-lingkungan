const { UserPostLikeHistory, Post, User, Notification } = require('../../../models');
const { sendNotificationToUser } = require('../../../services/firebaseService');

exports.likePost = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { post_id } = req.params;

    if (isNaN(post_id)) {
      return res.status(400).json({ message: "Invalid post ID" });
    }

    const post = await Post.findByPk(post_id, {
      include: { model: User, as: 'user' }, // Pastikan asosiasi sudah benar
    });
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const existingLike = await UserPostLikeHistory.findOne({ where: { user_id, post_id } });
    if (existingLike) {
      return res.status(400).json({ message: "You have already liked this post" });
    }

    await UserPostLikeHistory.create({ user_id, post_id });
    await post.increment('total_likes');

    // 🔔 Kirim notifikasi jika yang like bukan pemilik postingan
    if (user_id !== post.user_id) {
      const liker = await User.findByPk(user_id);
      const targetUser = post.user;

      const notifTitle = `${liker.username}`;
      const notifMessage = `telah menyukai postingan Anda`;

      // Simpan notifikasi ke DB
      await Notification.create({
        user_id: targetUser.id,
        title: notifTitle,
        message: notifMessage,
        type: "forum",
        sent_by: "system",
        role_target: "user",
        is_read: false,
      });

      // Kirim push notif FCM
      if (targetUser.fcm_token) {
        await sendNotificationToUser(
          targetUser.fcm_token,
          notifTitle,
          notifMessage,
          {
            type: "like",
            route: "notification",
            post_id: post.id.toString(),
          }
        );
      }
    }

    return res.status(201).json({ message: "Post liked successfully" });
  } catch (error) {
    console.error("❌ Error liking post:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};


exports.unlikePost = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { post_id } = req.params;

    if (isNaN(post_id)) {
      return res.status(400).json({ message: "Invalid post ID" });
    }

    const like = await UserPostLikeHistory.findOne({ where: { user_id, post_id } });
    if (!like) {
      return res.status(404).json({ message: "You haven't liked this post" });
    }

    await like.destroy();

    const post = await Post.findByPk(post_id, {
      include: { model: User, as: 'user' },
    });

    if (post) {
      await post.decrement('total_likes');

      // 🔻 Hapus notifikasi like jika sebelumnya dikirim
      if (user_id !== post.user_id) {
        const liker = await User.findByPk(user_id);

        await Notification.destroy({
          where: {
            user_id: post.user.id, // pemilik postingan
            title: liker.username,
            message: 'telah menyukai postingan Anda',
            type: 'forum',
          },
        });
      }
    }

    return res.status(200).json({ message: "Like removed successfully" });
  } catch (error) {
    console.error("❌ Error unliking post:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};