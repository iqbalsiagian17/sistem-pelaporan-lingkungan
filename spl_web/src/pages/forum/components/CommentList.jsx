import React from "react";
import CommentItem from "./CommentItem";
import AvatarDisplay from "./AvatarDisplay";

const CommentList = ({ rootComments, getReplies, canEdit, onEdit, onDelete }) => {
  return (
    <div className="d-flex flex-column gap-3">
      {rootComments.map((comment) => (
        <div key={comment.id}>
          <CommentItem comment={comment} canEdit={canEdit} onEdit={onEdit} onDelete={onDelete} />

          {getReplies(comment.id).map((reply) => (
            <div
              key={reply.id}
              className="d-flex align-items-start ms-5 mt-2 justify-content-between"
            >
              <div className="d-flex">
                <AvatarDisplay
                  username={reply.user?.username}
                  profile_picture={reply.user?.profile_picture}
                  size={28}
                  fontSize={13}
                />
                <div className="ms-2">
                  <p className="fw-semibold mb-1 text-secondary">@{reply.user?.username}</p>
                  <p className="mb-1 small text-muted">
                    Membalas: <span className="text-dark">{reply.content}</span>
                  </p>
                </div>
              </div>
              <Dropdown>
                <Dropdown.Toggle variant="link" className="text-muted p-0 border-0">
                  <i className="bi bi-three-dots-vertical"></i>
                </Dropdown.Toggle>
                <Dropdown.Menu align="end">
                  {canEdit(reply.user?.id) && (
                    <Dropdown.Item onClick={() => onEdit(reply)}>Edit Komentar</Dropdown.Item>
                  )}
                  <Dropdown.Item className="text-danger" onClick={() => onDelete(reply.id)}>
                    Hapus Komentar
                  </Dropdown.Item>
                </Dropdown.Menu>
              </Dropdown>
            </div>
          ))}
        </div>
      ))}
    </div>
  );
};

export default CommentList;