const { Post, User, PostImage, Comment, UserPostLikeHistory, Notification } = require('../../../models');
const { sendNotificationToUser } = require('../../../services/firebaseService');
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// ✅ Konfigurasi Multer untuk Upload Gambar
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = "uploads/forum/";
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});
const upload = multer({ storage }).array("images", 10); // Maksimal 10 gambar

// ✅ CREATE POST (User Only)
exports.createPost = async (req, res) => {
    upload(req, res, async (err) => {
        if (err) {
            return res.status(400).json({ message: "File upload error", error: err.message });
        }

        try {
            const { content } = req.body;
            const user_id = req.user.id;

            if (!content) {
                return res.status(400).json({ message: "Content is required" });
            }

            const newPost = await Post.create({ user_id, content });

            let images = [];
            if (req.files.length > 0) {
                images = req.files.map((file) => ({
                    post_id: newPost.id,
                    image: `uploads/forum/${file.filename}`
                }));

                await PostImage.bulkCreate(images);
            }

            const fullPost = await Post.findByPk(newPost.id, {
                include: [
                    { model: User, as: "user", attributes: ["id", "username"] },
                    { model: PostImage, as: "images" },
                    { model: Comment, as: "comments" }
                ]
            });

            res.status(201).json({ message: "Post created successfully", post: fullPost });
        } catch (error) {
            console.error("Error creating post:", error);
            res.status(500).json({ message: "Server error", error: error.message });
        }
    });
};

// ✅ UPDATE POST (Only Owner)
exports.updatePost = async (req, res) => {
  upload(req, res, async (err) => {
    if (err) {
      return res.status(400).json({ message: "File upload error", error: err.message });
    }

    try {
      const { id } = req.params;
      const { content, keptOldImages } = req.body;
      const user_id = req.user.id;

      console.log("📩 Received body:", req.body);
      console.log("📎 Files received:", req.files?.length || 0);

            // ✅ Parse dan normalisasi disini (urutan penting!)
            let keptImages = [];
      if (typeof keptOldImages === "string") {
        try {
          keptImages = JSON.parse(keptOldImages);
        } catch (parseError) {
          return res.status(400).json({ message: "Invalid keptOldImages format", error: parseError.message });
        }
      } else if (Array.isArray(keptOldImages)) {
        keptImages = keptOldImages;
      }


      const normalizedKeptImages = keptImages.map(p => p.replace(/\\/g, '/'));

      const post = await Post.findByPk(id, {
        include: { model: PostImage, as: "images" }
      });

      if (!post) return res.status(404).json({ message: "Post not found" });
      if (post.user_id !== user_id) return res.status(403).json({ message: "Unauthorized" });

      // ✏️ Update konten jika berubah
      if (content && content !== post.content) {
        post.content = content;
        post.is_edited = true;
        await post.save();
      }

      // 🔥 Debug
      console.log("🧪 normalizedKeptImages:", normalizedKeptImages);
      console.log("🧪 image paths in DB:", post.images.map(img => img.image));

      // 🗑️ Hapus gambar yang tidak dipertahankan
      for (const image of post.images) {
        const shouldKeep = normalizedKeptImages.includes(image.image.replace(/\\/g, '/'));
        console.log(`🧹 Gambar ${image.image} → ${shouldKeep ? '✅ Dibiarkan' : '❌ Dihapus'}`);

        if (!shouldKeep) {
          if (fs.existsSync(image.image)) {
            fs.unlinkSync(image.image);
          }
          await image.destroy();
        }
      }

      // 📥 Simpan gambar baru jika ada
      if (req.files.length > 0) {
        const newImages = req.files.map((file) => ({
          post_id: post.id,
          image: `uploads/forum/${file.filename}`,
        }));
        await PostImage.bulkCreate(newImages);
      }

      // 🔁 Ambil ulang post
      const updatedPost = await Post.findByPk(post.id, {
        include: [
          { model: User, as: "user", attributes: ["id", "username", "profile_picture"] },
          { model: PostImage, as: "images" },
          {
            model: Comment,
            as: "comments",
            include: { model: User, as: "user", attributes: ["id", "username", "profile_picture"] },
          },
        ],
      });

      return res.status(200).json({ message: "Post updated successfully", post: updatedPost });
    } catch (error) {
      console.error("❌ Error updating post:", error);
      return res.status(500).json({ message: "Server error", error: error.message });
    }
  });
};




exports.getAllPosts = async (req, res) => {
    try {
      const userId = req.user?.id || null;
  
      const posts = await Post.findAll({
        include: [
          { model: User, as: "user", attributes: ["id", "username","profile_picture"] },
          { model: PostImage, as: "images" },
          {
            model: Comment,
            as: "comments",
            include: { model: User, as: "user", attributes: ["id", "username"] }
          },
          {
            model: UserPostLikeHistory,
            as: "likesRelation",
            where: userId ? { user_id: userId } : undefined,
            required: false // agar tetap bisa fetch meskipun belum di-like user
          }
        ],
        order: [["createdAt", "DESC"]]
      });
  
      const result = posts.map(post => {
        const plainPost = post.get({ plain: true });
  
        return {
          ...plainPost,
          is_liked: plainPost.likesRelation && plainPost.likesRelation.length > 0,
          is_edited: plainPost.is_edited ?? false, // ✅ TAMBAHKAN INI
        };
      });
  
      return res.status(200).json({
        message: "Posts retrieved successfully",
        posts: result
      });
  
    } catch (error) {
      console.error("❌ Error fetching posts:", error);
      return res.status(500).json({ message: "Server error", error: error.message });
    }
  };


// ✅ GET POST DETAIL BY ID
exports.getPostById = async (req, res) => {
    try {
        const { id } = req.params;

        const post = await Post.findByPk(id, {
            include: [
                { model: User, as: "user", attributes: ["id", "username", "profile_picture"] },
                { model: PostImage, as: "images" },
                { 
                    model: Comment, 
                    as: "comments",
                    include: { model: User, as: "user", attributes: ["id", "username", "profile_picture"] }
                }
            ]
        });

        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }

      res.status(200).json({
        message: "Post retrieved successfully",
        post: {
          ...post.get({ plain: true }),
          is_edited: post.is_edited ?? false, // ✅ TAMBAHKAN INI
        }
      });
    } catch (error) {
        console.error("Error fetching post:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ CREATE COMMENT (User Only)
exports.createComment = async (req, res) => {
  try {
    const { post_id, content, parent_id } = req.body;
    const user_id = req.user.id;

    if (!post_id || !content) {
      return res.status(400).json({ message: "Post ID and content are required" });
    }

    // ✅ Validasi parent_id jika ada
    if (parent_id) {
      const parentComment = await Comment.findByPk(parent_id);
      if (!parentComment || parentComment.post_id !== parseInt(post_id)) {
        return res.status(400).json({ message: "Invalid parent comment" });
      }
    }

    // Buat komentar (reply jika parent_id disertakan)
    const newComment = await Comment.create({
      post_id,
      user_id,
      content,
      parent_id: parent_id || null,
    });

    const fullComment = await Comment.findByPk(newComment.id, {
      include: { model: User, as: "user", attributes: ["id", "username"] }
    });

    const post = await Post.findByPk(post_id);
    if (!post) {
      return res.status(404).json({ message: "Postingan tidak ditemukan" });
    }

    const targetUser = await User.findByPk(post.user_id, {
      attributes: ["id", "fcm_token", "username"]
    });

    if (post.user_id !== user_id) {
      const notifTitle = `${fullComment.user.username}`;
      const notifMessage = `berkomentar: "${content.length > 80 ? content.slice(0, 77) + '...' : content}"`;

      await Notification.create({
        user_id: targetUser.id,
        title: notifTitle,
        message: notifMessage,
        type: "forum",
        sent_by: "system",
        role_target: "user",
        is_read: false,
      });

      if (targetUser.fcm_token) {
        await sendNotificationToUser(
          targetUser.fcm_token,
          notifTitle,
          notifMessage,
          {
            type: "comment",
            route: "notification",
            post_id: post.id.toString(),
          }
        );
      }
    }

    if (parent_id) {
    const parentComment = await Comment.findByPk(parent_id, {
      include: { model: User, as: "user", attributes: ["id", "fcm_token", "username"] }
    });

    if (parentComment && parentComment.user.id !== user_id) {
      const replyNotifTitle = `${fullComment.user.username}`;
      const replyNotifMessage = `membalas komentarmu: "${content.length > 80 ? content.slice(0, 77) + '...' : content}"`;

      await Notification.create({
        user_id: parentComment.user.id,
        title: replyNotifTitle,
        message: replyNotifMessage,
        type: "forum",
        sent_by: "system",
        role_target: "user",
        is_read: false,
      });

      if (parentComment.user.fcm_token) {
        await sendNotificationToUser(
          parentComment.user.fcm_token,
          replyNotifTitle,
          replyNotifMessage,
          {
            type: "comment",
            route: "notification",
            post_id: post.id.toString(),
            parent_id: parentComment.id.toString(),
          }
        );
      }
    }
  }

    res.status(201).json({ message: "Comment added successfully", comment: fullComment });

  } catch (error) {
    console.error("Error adding comment:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};


  


exports.updateComment = async (req, res) => {
    try {
      const { id } = req.params;
      const { content } = req.body;
      const user_id = req.user.id;
  
      console.log("📝 UpdateComment → ID:", id);
      console.log("📝 UpdateComment → Content:", content);
      console.log("📝 UpdateComment → UserID:", user_id);
  
      const comment = await Comment.findByPk(id);
  
      if (!comment) {
        console.log("❌ Comment not found");
        return res.status(404).json({ message: "Comment not found" });
      }
  
      if (comment.user_id !== user_id) {
        console.log("❌ Unauthorized");
        return res.status(403).json({ message: "Unauthorized to update this comment" });
      }
  
      comment.content = content;
      comment.is_edited = true; // ✅ tandai sebagai sudah di-edit
      await comment.save();
  
      console.log("✅ Comment updated:", comment.content);
      return res.status(200).json({ message: "Comment updated successfully" });
    } catch (error) {
      console.error("❌ Error updating comment:", error);
      return res.status(500).json({ message: "Server error", error: error.message });
    }
  };
  
  

// ✅ DELETE POST (Only Owner)
exports.deletePost = async (req, res) => {
    try {
        const { id } = req.params;
        const user_id = req.user.id;

        const post = await Post.findByPk(id, { include: { model: PostImage, as: "images" } });

        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }

        if (post.user_id !== user_id) {
            return res.status(403).json({ message: "You do not have permission to delete this post" });
        }

        // Hapus gambar terkait
        for (const image of post.images) {
            if (fs.existsSync(image.image)) {
                fs.unlinkSync(image.image);
            }
        }

        await PostImage.destroy({ where: { post_id: id } });
        await Comment.destroy({ where: { post_id: id } });
        await post.destroy();

        res.status(200).json({ message: "Post deleted successfully" });
    } catch (error) {
        console.error("Error deleting post:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

// ✅ DELETE COMMENT (Only Owner)
exports.deleteComment = async (req, res) => {
    try {
        const { id } = req.params;
        const user_id = req.user.id;

        const comment = await Comment.findByPk(id);

        if (!comment) {
            return res.status(404).json({ message: "Comment not found" });
        }

        if (comment.user_id !== user_id) {
            return res.status(403).json({ message: "You do not have permission to delete this comment" });
        }

        await comment.destroy();

        res.status(200).json({ message: "Comment deleted successfully" });
    } catch (error) {
        console.error("Error deleting comment:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};
