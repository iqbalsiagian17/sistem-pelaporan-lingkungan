import React from "react";
import PostHeader from "./PostHeader";
import PostContent from "./PostContent";
import CommentList from "./CommentList";
import PostCommentBox from "./PostCommentBox";

const PostCard = ({
  post,
  onDeletePost,
  onEditPost,
  onPinPost,
  onDeleteComment,
  onEditComment,
  onImageClick,
  currentUserId,
}) => {
  const hasParentId = post.comments?.some((c) => c.hasOwnProperty("parent_id"));

  const rootComments = hasParentId
    ? post.comments.filter((c) => c.parent_id === null)
    : post.comments;

  const replies = hasParentId
    ? post.comments.filter((c) => c.parent_id !== null)
    : [];

  const getReplies = (parentId) => replies.filter((r) => r.parent_id === parentId);
  const canEdit = (commentUserId) => commentUserId === currentUserId;
  const [showComments, setShowComments] = React.useState(false);


  return (
    <div className="card shadow-sm mb-2 rounded">
      <PostHeader post={post} onEditPost={onEditPost} onDeletePost={onDeletePost} onPinPost={onPinPost} />
      <PostContent
        content={post.content}
        images={post.images}
        onImageClick={onImageClick}
        totalLikes={post.total_likes}
        totalComments={post.comments?.length}
      />
      
      <div className="border-top px-3 py-2">
        <div className="d-flex justify-content-around text-muted py-2 border-bottom">
          <div role="button" className="d-flex align-items-center gap-2">
            <i className="bi bi-hand-thumbs-up"></i> <span>Suka</span>
          </div>
          <div
            role="button"
            className="d-flex align-items-center gap-2"
            onClick={() => setShowComments((prev) => !prev)}
          >
            <i className="bi bi-chat-left-text"></i> <span>Komentar</span>
          </div>
        </div>

        {showComments && (
          <>
            <p className="text-muted mt-3">Komentar ({post.comments?.length})</p>

            <CommentList
              rootComments={rootComments}
              getReplies={getReplies}
              canEdit={canEdit}
              onEdit={onEditComment}
              onDelete={onDeleteComment}
            />

            <div className="mt-3">
              <PostCommentBox
                postId={post.id}
                onCommentSuccess={() => window.location.reload()}
              />
            </div>
          </>
        )}
      </div>

    </div>
  );
};

export default PostCard;
