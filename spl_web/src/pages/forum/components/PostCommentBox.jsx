import React, { useState } from "react";
import { usePost } from "../../../context/PostContext";
import AvatarCircle from "./AvatarCircle";
import { Form, Button, Spinner } from "react-bootstrap";

const PostCommentBox = ({ postId, onCommentSuccess }) => {
  const { addComment } = usePost();
  const [comment, setComment] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!comment.trim()) return;

    try {
      setIsSubmitting(true);
      await addComment({ post_id: postId, content: comment });
      setComment("");
      if (onCommentSuccess) onCommentSuccess();
    } catch (err) {
      alert("❌ Gagal mengirim komentar: " + err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Form onSubmit={handleSubmit} className="d-flex align-items-start gap-2 mt-2">
      <AvatarCircle username={"anon"} size={36} fontSize={14} />
      <Form.Control
        as="textarea"
        rows={1}
        className="form-control"
        placeholder="Tulis komentar..."
        value={comment}
        onChange={(e) => setComment(e.target.value)}
        style={{ resize: "none" }}
        disabled={isSubmitting}
      />
      <Button
        type="submit"
        variant="primary"
        size=""
        disabled={isSubmitting || !comment.trim()}
      >
        {isSubmitting ? (
          <Spinner size="sm" animation="border" />
        ) : (
          "Kirim"
        )}
      </Button>
    </Form>
  );
};

export default PostCommentBox;
