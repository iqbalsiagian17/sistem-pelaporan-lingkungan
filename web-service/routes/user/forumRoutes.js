const express = require("express");
const router = express.Router();
const forumController = require("../../controllers/user/forum/forumController");
const authMiddleware = require("../../middleware/authMiddleware");

// Forum Routes
router.post("/", authMiddleware, forumController.createPost);
router.get("/", authMiddleware, forumController.getAllPosts);
router.get("/:id", authMiddleware, forumController.getPostById);
router.post("/comment", authMiddleware, forumController.createComment);
router.delete("/:id", authMiddleware, forumController.deletePost);
router.delete("/comment/:id", authMiddleware, forumController.deleteComment);

module.exports = router;
