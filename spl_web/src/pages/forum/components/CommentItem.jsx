import React from "react";
import AvatarDisplay from "./AvatarDisplay";
import { formatPostDate } from "../../../utils/formatDate";

const CommentItem = ({ comment, canEdit, onEdit, onDelete }) => {
  const timeAgo = formatPostDate(comment.createdAt);

  return (
    <div className="d-flex justify-content-between align-items-start position-relative">
      {/* Kiri: Avatar dan konten */}
      <div className="d-flex">
        <AvatarDisplay
          username={comment.user?.username}
          profile_picture={comment.user?.profile_picture}
          size={30}
          fontSize={14}
        />
        <div className="ms-2">
          <div className="d-flex align-items-center gap-2 flex-wrap">
            <span className="fw-semibold mb-0">@{comment.user?.username}</span>
            <span className="text-muted small">• {timeAgo}</span>
            {comment.is_edited && (
              <span
                className="badge text-secondary bg-light border"
                style={{ fontSize: "0.65rem" }}
              >
                diedit
              </span>
            )}
          </div>
          <p className="mb-1">{comment.content}</p>
        </div>
      </div>

      {/* Kanan: Dropdown Bootstrap */}
      <div className="dropdown">
        <button
          type="button"
          className="btn p-0 dropdown-toggle hide-arrow"
          data-bs-toggle="dropdown"
          aria-expanded="false"
        >
          <i className="bx bx-dots-vertical-rounded" style={{ fontSize: "18px" }}></i>
        </button>
        <div className="dropdown-menu dropdown-menu-end">
          {canEdit(comment.user?.id) && (
            <button
              className="dropdown-item"
              onClick={() => onEdit(comment)}
            >
              <i className="bx bx-edit-alt me-1"></i> Edit Komentar
            </button>
          )}
          <button
            className="dropdown-item text-danger"
            onClick={() => onDelete(comment.id)}
          >
            <i className="bx bx-trash me-1"></i> Hapus Komentar
          </button>
        </div>
      </div>
    </div>
  );
};

export default CommentItem;
