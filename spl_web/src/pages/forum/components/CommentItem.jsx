import React from "react";
import { Dropdown } from "react-bootstrap";
import AvatarDisplay from "./AvatarDisplay";

const CommentItem = ({ comment, canEdit, onEdit, onDelete }) => {
  return (
    <div className="d-flex justify-content-between align-items-start">
      <div className="d-flex">
        <AvatarDisplay
          username={comment.user?.username}
          profile_picture={comment.user?.profile_picture}
          size={30}
          fontSize={14}
        />
        <div className="ms-2">
          <p className="fw-semibold mb-1">@{comment.user?.username}</p>
          <p className="mb-1">{comment.content}</p>
        </div>
      </div>
      <Dropdown>
        <Dropdown.Toggle variant="link" className="text-muted p-0 border-0">
          <i className="bi bi-three-dots-vertical"></i>
        </Dropdown.Toggle>
        <Dropdown.Menu align="end">
          {canEdit(comment.user?.id) && (
            <Dropdown.Item onClick={() => onEdit(comment)}>Edit Komentar</Dropdown.Item>
          )}
          <Dropdown.Item className="text-danger" onClick={() => onDelete(comment.id)}>
            Hapus Komentar
          </Dropdown.Item>
        </Dropdown.Menu>
      </Dropdown>
    </div>
  );
};

export default CommentItem;