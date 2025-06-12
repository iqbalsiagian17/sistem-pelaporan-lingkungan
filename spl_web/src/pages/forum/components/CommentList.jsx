import React, { useState } from "react";
import CommentItem from "./CommentItem";
import AvatarDisplay from "./AvatarDisplay";

const CommentList = ({ rootComments, getReplies, canEdit, onEdit, onDelete }) => {
  const [activeReplyMenuId, setActiveReplyMenuId] = useState(null);
  const [visibleRootCount, setVisibleRootCount] = useState(5);
  const [visibleRepliesCount, setVisibleRepliesCount] = useState({}); // { commentId: number }

  const handleShowMoreRoot = () => {
    if (visibleRootCount < 10) {
      setVisibleRootCount(10);
    } else {
      setVisibleRootCount(rootComments.length);
    }
  };

  const handleShowMoreReplies = (commentId, totalReplies) => {
    setVisibleRepliesCount((prev) => ({
      ...prev,
      [commentId]: totalReplies,
    }));
  };

  return (
    <div className="d-flex flex-column gap-3">
      {rootComments.slice(0, visibleRootCount).map((comment) => {
        const replies = getReplies(comment.id);
        const visibleCount = visibleRepliesCount[comment.id] || 3;
        const visibleReplies = replies.slice(0, visibleCount);

        return (
          <div key={comment.id}>
            <CommentItem
              comment={comment}
              canEdit={canEdit}
              onEdit={onEdit}
              onDelete={onDelete}
            />

            {visibleReplies.map((reply) => (
              <div
                key={reply.id}
                className="d-flex align-items-start ms-5 mt-2 justify-content-between position-relative"
              >
                <div className="d-flex">
                  <AvatarDisplay
                    username={reply.user?.username}
                    profile_picture={reply.user?.profile_picture}
                    size={28}
                    fontSize={13}
                  />
                  <div className="ms-2">
                    <div className="d-flex align-items-center gap-2 flex-wrap">
                      <p className="fw-semibold mb-0 text-secondary">@{reply.user?.username}</p>
                    </div>
                    <p className="mb-1 small text-muted">
                      Membalas: <span className="text-dark">{reply.content}</span>
                    </p>
                  </div>
                </div>

                <div className="dropdown" style={{ position: "relative" }}>
                  <button
                    className="btn btn-link text-muted p-0 border-0"
                    onClick={() =>
                      setActiveReplyMenuId((prev) => (prev === reply.id ? null : reply.id))
                    }
                  >
                    <i className="bi bi-three-dots-vertical"></i>
                  </button>
                  {activeReplyMenuId === reply.id && (
                    <div
                      className="dropdown-menu dropdown-menu-end show"
                      style={{ position: "absolute", top: "100%", right: 0 }}
                    >
                      {canEdit(reply.user?.id) && (
                        <button
                          className="dropdown-item"
                          onClick={() => {
                            onEdit(reply);
                            setActiveReplyMenuId(null);
                          }}
                        >
                          Edit Komentar
                        </button>
                      )}
                      <button
                        className="dropdown-item text-danger"
                        onClick={() => {
                          onDelete(reply.id);
                          setActiveReplyMenuId(null);
                        }}
                      >
                        Hapus Komentar
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}

            {/* Tombol untuk memunculkan semua balasan */}
            {replies.length > visibleReplies.length && (
              <button
                className="btn btn-link text-secondary ms-5 mt-1 px-0"
                onClick={() => handleShowMoreReplies(comment.id, replies.length)}
              >
                Lihat balasan lainnya
              </button>
            )}
          </div>
        );
      })}

      {/* Tombol untuk komentar utama */}
      {rootComments.length > visibleRootCount && (
        <button
          className="btn btn-link text-primary px-0 mt-2"
          onClick={handleShowMoreRoot}
        >
          {visibleRootCount < 10 ? "Lihat lainnya" : "Lihat semua komentar"}
        </button>
      )}
    </div>
  );
};

export default CommentList;
