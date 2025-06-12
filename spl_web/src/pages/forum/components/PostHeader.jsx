import React from "react";
import { Dropdown } from "react-bootstrap";
import AvatarDisplay from "./AvatarDisplay";
import { formatPostDate } from "../../../utils/formatDate"; // ✅ gunakan fungsi dari utils

const PostHeader = ({ post, onEditPost, onDeletePost, onPinPost }) => {
  const formattedDate = formatPostDate(post.createdAt); // ✅ panggil fungsi utils di sini

  return (
    <div className="px-3 pt-3 d-flex justify-content-between align-items-start">
      {/* Kiri: Avatar + Info user */}
      <div className="d-flex w-100">
        <AvatarDisplay
          username={post.user?.username}
          profile_picture={post.user?.profile_picture}
          size={48}
          fontSize={18}
        />
        <div className="ms-2 flex-grow-1">
          <div className="fw-semibold d-flex align-items-center gap-2">
            {post.user?.username}
            {post.is_pinned && (
              <span className="badge bg-success">📌 Tersemat</span>
            )}
          </div>

          <div className="text-muted small d-flex align-items-center gap-2 flex-wrap">
            <span>@{post.user?.username}</span>
            <span>• {formattedDate}</span>
          </div>
        </div>
      </div>

      {/* Kanan: Dropdown */}
<div className="dropdown">
      <button
        type="button"
        className="btn p-0 border-0 bg-transparent"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        <i className="bi bi-three-dots-vertical text-muted" style={{ fontSize: "1.2rem" }}></i>
      </button>

      <ul className="dropdown-menu dropdown-menu-end">
        <li>
          <button className="dropdown-item" onClick={() => onPinPost(post.id)}>
            {post.is_pinned ? "Unpin Post" : "Pin Post"}
          </button>
        </li>
        <li>
          <button className="dropdown-item" onClick={() => onEditPost(post)}>
            Edit Postingan
          </button>
        </li>
        <li>
          <button className="dropdown-item text-danger" onClick={() => onDeletePost(post)}>
            Hapus Postingan
          </button>
        </li>
      </ul>
    </div>
    </div>
  );
};

export default PostHeader;
