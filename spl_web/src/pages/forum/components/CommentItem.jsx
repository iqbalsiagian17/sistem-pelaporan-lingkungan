import React, { useState } from "react";
import AvatarDisplay from "./AvatarDisplay";
import { formatPostDate } from "../../../utils/formatDate";

const CommentItem = ({ comment, canEdit, onEdit, onDelete }) => {
  const timeAgo = formatPostDate(comment.createdAt);
  const [showMenu, setShowMenu] = useState(false);

  const toggleMenu = () => setShowMenu((prev) => !prev);

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

      {/* Kanan: Dropdown manual */}
      <div className="dropdown" style={{ position: "relative" }}>
        <button
          className="btn btn-link text-muted p-0 border-0"
          onClick={toggleMenu}
          aria-expanded={showMenu}
        >
          <i className="bi bi-three-dots-vertical" style={{ fontSize: "1.1rem" }}></i>
        </button>

        {showMenu && (
          <div
            className="dropdown-menu dropdown-menu-end show"
            style={{ position: "absolute", top: "100%", right: 0, zIndex: 1000 }}
          >
            {canEdit(comment.user?.id) && (
              <button
                className="dropdown-item"
                onClick={() => {
                  onEdit(comment);
                  setShowMenu(false);
                }}
              >
                Edit Komentar
              </button>
            )}
            <button
              className="dropdown-item text-danger"
              onClick={() => {
                onDelete(comment.id);
                setShowMenu(false);
              }}
            >
              Hapus Komentar
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default CommentItem;
