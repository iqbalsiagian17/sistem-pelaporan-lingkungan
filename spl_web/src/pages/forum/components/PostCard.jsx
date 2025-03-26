import React from "react";
import { Dropdown } from "react-bootstrap";
import PostCommentBox from "./PostCommentBox";
import AvatarCircle from "./AvatarCircle";

const PostCard = ({ post, onDeletePost, onPinPost, onDeleteComment, onImageClick }) => {
  return (
    <div className="card shadow-sm mb-4 border rounded-lg">
      {/* Post Header */}
      <div className="card-header d-flex justify-content-between align-items-start">
        <div className="d-flex align-items-center">
          <AvatarCircle username={post.user?.username} />
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
          <span>{post.likes || 0} suka</span>
        </div>

        {/* Gambar */}
        {post.images?.length > 0 && (
          <div className="mt-3">
            {post.images.length === 1 && (
              <div className="mb-2">
                <img
                  src={`http://localhost:3000/${post.images[0].image}`}
                  alt="post-img"
                  className="w-100 rounded-3"
                  onClick={() => onImageClick(post.images, 0)}
                  style={{ height: "500px", objectFit: "cover", cursor: "pointer" }}
                  />
              </div>
            )}

            {post.images.length === 2 && (
              <div className="row g-2">
                {post.images.map((img, i) => (
                  <div key={img.id} className="col-6">
                    <img
                      src={`http://localhost:3000/${img.image}`}
                      className="w-100 rounded-3"
                      onClick={() => onImageClick(post.images, i)}
                      style={{ height: "500px", objectFit: "cover", cursor: "pointer" }}
                    />
                  </div>
                ))}
              </div>
            )}

            {post.images.length === 3 && (
              <div className="row g-2">
                <div className="col-12 mb-2">
                  <img
                    src={`http://localhost:3000/${post.images[0].image}`}
                    className="w-100 rounded-3"
                    onClick={() => onImageClick(post.images, 0)}
                    style={{ height: "500px", objectFit: "cover", cursor: "pointer" }}
                    />
                </div>
                {post.images.slice(1).map((img, i) => (
                  <div key={img.id} className="col-6">
                    <img
                      src={`http://localhost:3000/${img.image}`}
                      className="w-100 rounded-3"
                      onClick={() => onImageClick(post.images, i + 1)}
                      style={{ height: "500px", objectFit: "cover", cursor: "pointer" }}
                    />
                  </div>
                ))}
              </div>
            )}

            {post.images.length >= 4 && (
              <div className="row g-2">
                {post.images.slice(0, 4).map((img, i) => (
                  <div key={img.id} className="col-6 position-relative">
                    <img
                      src={`http://localhost:3000/${img.image}`}
                      className="w-100 rounded-3"
                      style={{ height: "500px", objectFit: "cover", cursor: "pointer" }}
                      onClick={() => onImageClick(post.images, i)}
                      
                    />
                    {i === 3 && post.images.length > 4 && (
                      <div
                        className="position-absolute top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center bg-dark bg-opacity-50 text-white rounded-3"
                        style={{ fontSize: "1.5rem", cursor: "pointer" }}
                        onClick={() => onImageClick(post.images, i)}
                      >
                        +{post.images.length - 4}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>

      {/* Comments */}
      <div className="card-footer">
        <p className="text-muted mb-2">Komentar ({post.comments?.length})</p>
        <div className="d-flex flex-column gap-3">
          {post.comments?.map((comment) => (
            <div key={comment.id} className="d-flex align-items-start justify-content-between">
              <div className="d-flex">
                <AvatarCircle username={comment.user?.username} size={30} fontSize={14} />
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
                  <Dropdown.Item className="text-danger" onClick={() => onDeleteComment(comment.id)}>
                    Hapus Komentar
                  </Dropdown.Item>
                </Dropdown.Menu>
              </Dropdown>
            </div>
          ))}
        </div>
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
