import React, { useState } from "react";
import { usePost } from "../../../context/PostContext";
import AvatarCircle from "./AvatarCircle";


const PostCommentBox = ({ postId, onCommentSuccess }) => {
  const { addComment } = usePost();
  const [comment, setComment] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!comment.trim()) return;

    try {
      await addComment({ post_id: postId, content: comment });
      setComment("");
      if (onCommentSuccess) onCommentSuccess();
    } catch (err) {
      alert("❌ Gagal mengirim komentar: " + err.message);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="d-flex gap-2 mt-2">
      {/* Avatar Inisial A dengan Background Hijau */}
      <AvatarCircle username={"anon"} size={30} fontSize={14} />
      <input
        type="text"
        className="form-control form-control"
        placeholder="Tulis komentar..."
        value={comment}
        onChange={(e) => setComment(e.target.value)}
      />
      <button type="submit" className="btn btn-primary btn">
        Kirim
      </button>
    </form>
  );
};

export default PostCommentBox;
