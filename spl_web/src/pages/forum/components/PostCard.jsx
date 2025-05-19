import React from "react";
import { Dropdown } from "react-bootstrap";
import PostCommentBox from "./PostCommentBox";
import AvatarDisplay from "./AvatarDisplay";

const PostCard = ({ post, onDeletePost, onEditPost, onPinPost, onDeleteComment, onEditComment, onImageClick, currentUserId }) => {
  const [expandedComments, setExpandedComments] = React.useState({});

  // 🔄 Pisahkan komentar root dan reply
  const rootComments = post.comments?.filter(c => c.parent_id === null) || [];
  const replies = post.comments?.filter(c => c.parent_id !== null) || [];

  const getReplies = (parentId) => replies.filter(r => r.parent_id === parentId);

  const toggleReplies = (commentId) => {
    setExpandedComments(prev => ({
      ...prev,
      [commentId]: !prev[commentId]
    }));
  };

  const canEdit = (commentUserId) => commentUserId === currentUserId;

  return (
    <div className="card shadow-sm mb-4 border rounded-lg">
      {/* Post Header */}
      <div className="card-header d-flex justify-content-between align-items-start">
        <div className="d-flex align-items-center">
          <AvatarDisplay
            username={post.user?.username}
            profile_picture={post.user?.profile_picture}
          />
          <div className="ms-3">
            <p className="mb-0 text-dark fw-semibold">@{post.user?.username}</p>
            <div className="d-flex align-items-center gap-2">
              <small className="text-muted">{new Date(post.createdAt).toLocaleString()}</small>
              {post.is_pinned && <span className="badge bg-success text-white">📌 Tersemat</span>}
            </div>
          </div>
        </div>
        <Dropdown>
          <Dropdown.Toggle variant="light" size="sm" className="border-0 text-muted">
            <i className="bi bi-three-dots-vertical"></i>
          </Dropdown.Toggle>
          <Dropdown.Menu align="end">
            <Dropdown.Item onClick={() => onPinPost(post.id)}>
              {post.is_pinned ? "Unpin Post" : "Pin Post"}
            </Dropdown.Item>
            <Dropdown.Item onClick={() => onEditPost(post)}>Edit Postingan</Dropdown.Item>
            <Dropdown.Item onClick={() => onDeletePost(post)} className="text-danger">
              Hapus Postingan
            </Dropdown.Item>
          </Dropdown.Menu>
        </Dropdown>
      </div>

      {/* Post Content */}
      <div className="card-body">
        <p className="text-dark">{post.content}</p>
        <div className="mt-2 text-muted small d-flex align-items-center gap-1">
          <i className="bi bi-heart-fill text-danger"></i>
          <span>{post.total_likes || 0} suka</span>
        </div>

        {/* Gambar */}
        {post.images?.length > 0 && (
          <div className="mt-3">
            {/* ... image rendering logic ... */}
          </div>
        )}
      </div>

      {/* Comments */}
      <div className="card-footer">
        <p className="text-muted mb-2">Komentar ({post.comments?.length})</p>
        <div className="d-flex flex-column gap-3">
          {rootComments.map((comment) => (
            <div key={comment.id} className="d-flex flex-column gap-2">
              {/* Root Comment */}
              <div className="d-flex align-items-start justify-content-between">
                <div className="d-flex">
                  <AvatarDisplay
                    username={comment.user?.username}
                    profile_picture={comment.user?.profile_picture}
                    size={30}
                    fontSize={14}
                  />
                  <div className="ms-3">
                    <p className="fw-bold text-primary mb-1">@{comment.user?.username}</p>
                    <p className="mb-1">{comment.content}</p>
                  </div>
                </div>
                <Dropdown>
                  <Dropdown.Toggle variant="link" className="p-0 text-muted border-0">
                    <i className="bi bi-three-dots-vertical"></i>
                  </Dropdown.Toggle>
                  <Dropdown.Menu align="end">
                    {canEdit(comment.user?.id) && (
                      <Dropdown.Item onClick={() => onEditComment(comment)}>Edit Komentar</Dropdown.Item>
                    )}
                    <Dropdown.Item className="text-danger" onClick={() => onDeleteComment(comment.id)}>Hapus Komentar</Dropdown.Item>
                  </Dropdown.Menu>
                </Dropdown>
              </div>

              {/* Replies */}
              {getReplies(comment.id).map((reply) => (
                <div key={reply.id} className="d-flex align-items-start ms-5 justify-content-between">
                  <div className="d-flex">
                    <AvatarDisplay
                      username={reply.user?.username}
                      profile_picture={reply.user?.profile_picture}
                      size={26}
                      fontSize={13}
                    />
                    <div className="ms-3">
                      <p className="fw-bold text-secondary mb-1">@{reply.user?.username}</p>
                      <p className="mb-1 text-muted small">
                        Membalas: <span className="text-dark">{reply.content}</span>
                      </p>
                    </div>
                  </div>
                  <Dropdown>
                    <Dropdown.Toggle variant="link" className="p-0 text-muted border-0">
                      <i className="bi bi-three-dots-vertical"></i>
                    </Dropdown.Toggle>
                    <Dropdown.Menu align="end">
                      {canEdit(reply.user?.id) && (
                        <Dropdown.Item onClick={() => onEditComment(reply)}>Edit Komentar</Dropdown.Item>
                      )}
                      <Dropdown.Item className="text-danger" onClick={() => onDeleteComment(reply.id)}>Hapus Komentar</Dropdown.Item>
                    </Dropdown.Menu>
                  </Dropdown>
                </div>
              ))}
            </div>
          ))}
        </div>

        {/* Box untuk input komentar */}
        <PostCommentBox
          postId={post.id}
          onCommentSuccess={() => {
            if (typeof window !== "undefined") window.location.reload();
          }}
        />
      </div>
    </div>
  );
};

export default PostCard;
