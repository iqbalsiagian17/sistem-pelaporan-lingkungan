import { useState } from "react";
import { Modal, Carousel, Dropdown, ButtonGroup, Spinner } from "react-bootstrap";
import { usePost } from "../../context/PostContext";
import PostCard from "./components/PostCard";
import PostCreateModal from "./components/PostCreateModal";
import PostEditModal from "./components/PostEditModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import CommentEditModal from "./components/CommentEditModal";
import ToastNotification from "../../components/common/ToastNotification";
import PostCreateEntryBox from "./components/PostCreateEntryBox"; 
import ForumStatsCard from "./components/ForumStatsCard";
import AdminProfileCard from "./components/AdminProfileCard";


const ForumPage = () => {
  const {
    posts,
    setPosts, 
    addPost,
    editPost,
    removePost,
    removeComment,
    pinPost,
    editComment,
  } = usePost();

  const [selectedPost, setSelectedPost] = useState(null);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [filter, setFilter] = useState("terbaru");
  const [showImageModal, setShowImageModal] = useState(false);
  const [startIndex, setStartIndex] = useState(0);
  const [imageList, setImageList] = useState([]);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showEditCommentModal, setShowEditCommentModal] = useState(false);
  const [selectedComment, setSelectedComment] = useState(null);
  const [isProcessing, setIsProcessing] = useState(false);
  

  const [toast, setToast] = useState({
    show: false,
    message: "",
    variant: "success",
  });

  const showToast = (message, variant = "success") => {
    setToast({ show: true, message, variant });
  };

  const handleOpenImageModal = (images, index) => {
    setImageList(images);
    setStartIndex(index);
    setShowImageModal(true);
  };

  const handleOpenDeleteModal = (post) => {
    setSelectedPost(post);
    setShowDeleteModal(true);
  };

  const handleOpenEditComment = (comment) => {
    setSelectedComment(comment);
    setShowEditCommentModal(true);
  };

  const handleOpenEditModal = (post) => {
    setSelectedPost(post);
    setShowEditModal(true);
  };

  const handleConfirmDelete = async () => {
    try {
      setIsProcessing(true);
      await removePost(selectedPost.id);
      setShowDeleteModal(false);
      showToast("Postingan berhasil dihapus.", "danger");
    } catch (err) {
      alert(`Gagal menghapus: ${err.message}`);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleDeleteComment = async (commentId) => {
    try {
      setIsProcessing(true);
      await removeComment(commentId);
      showToast("Komentar berhasil dihapus.", "danger");
    } catch (err) {
      alert(`Gagal hapus komentar: ${err.message}`);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleEditComment = async (commentId, newContent) => {
    try {
      setIsProcessing(true);
      await editComment(commentId, newContent);
      showToast("Komentar berhasil diperbarui.");
    } catch (err) {
      alert(`Gagal edit komentar: ${err.message}`);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleCreatePost = async (formData) => {
    try {
      setIsProcessing(true);
      await addPost(formData);
      setShowCreateModal(false);
      showToast("Postingan berhasil ditambahkan.");
    } catch (err) {
      alert(`Gagal menambahkan post: ${err.message}`);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleEditPost = async (formData) => {
    try {
      setIsProcessing(true);
      await editPost(selectedPost.id, formData);
      setShowEditModal(false);
      showToast("Postingan berhasil diperbarui.");
    } catch (err) {
      alert(`Gagal mengedit post: ${err.message}`);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleAddComment = (postId, newComment) => {
    setPosts((prevPosts) =>
      prevPosts.map((post) =>
        post.id === postId
          ? {
              ...post,
              comments: [...(post.comments || []), newComment],
            }
          : post
      )
    );
    showToast("Komentar berhasil ditambahkan.");
  };

  const handleImageError = (e) => {
    e.target.onerror = null;
    e.target.src = "/assets/img/illustrations/error-image.png";
  };

  // Pisahkan pinned dan unpinned posts
  const pinned = posts.filter((p) => p.is_pinned);
  const notPinned = posts.filter((p) => !p.is_pinned);

    let filteredPosts = [...notPinned];
    if (filter === "terbaru") {
      filteredPosts.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  } else if (filter === "populer") {
    filteredPosts.sort((a, b) => (b.total_likes || 0) - (a.total_likes || 0));
  }

  const totalPosts = posts.length;
  const postsWithImages = posts.filter((p) => p.images?.length > 0).length;
  const totalComments = posts.reduce((sum, p) => sum + (p.comments?.length || 0), 0);
  const totalPinnedPosts = posts.filter(post => post.is_pinned).length;
  const mostLikedPost = posts.reduce((prev, curr) => {
    return (curr.total_likes || 0) > (prev.total_likes || 0) ? curr : prev;
  }, posts[0] || null);
  const adminPosts = posts.filter(p => p.user?.username === "Admin Balige Bersih");

  const lastPost = adminPosts
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))[0];

  const totalLikes = adminPosts.reduce((sum, p) => sum + (p.total_likes || 0), 0);
  const lastPostLikes = lastPost?.total_likes || 0;

  const adminProfile = {
    username: "Admin Balige Bersih",
    profile_picture: "", // tampil inisial
    totalPosts: adminPosts.length,
    totalLikes,
    lastPostData: lastPost
      ? {
          content: lastPost.content,
          image: lastPost.images?.[0]?.image || null,
          createdAt: lastPost.createdAt,
          likes: lastPost.total_likes || 0, // pastikan ini angka
        }
      : null,
  };


  const filterOptions = {
    terbaru: "Terbaru",
    populer: "Populer",
  };

  const top10Posts = [...posts]
  .filter(p => p.total_likes > 0)
  .sort((a, b) => (b.total_likes || 0) - (a.total_likes || 0))
  .slice(0, 10);


  const sortedPosts = [...pinned, ...filteredPosts];

  // 🔍 Tampilkan loading jika data belum tersedia
  const isInitialLoading = posts.length === 0 && !toast.show && !showCreateModal && !showEditModal;

  return (
  <div className="container-sm mx-auto px-3 py-4" style={{ maxWidth: "1500px" }}>
    <div className="row gy-4">
      {/* Kolom kiri: Profil admin */}
      <div className="col-md-3">
        <AdminProfileCard profile={adminProfile} />
      </div>

      {/* Kolom tengah: Form + daftar postingan */}
      <div className="col-md-5">
        <PostCreateEntryBox
          currentUser={{
            username: adminProfile.username,
            profile_picture: adminProfile.profile_picture,
          }}
          onCreate={handleCreatePost}
        />

        {/* Sorting */}
        <div className="d-flex justify-content-end align-items-center mb-3">
          <div className="d-flex align-items-center gap-2 w-100">
            <div className="flex-grow-1 border-top" />
            <span className="text-muted small">Sortir menurut:</span>
            <Dropdown>
              <Dropdown.Toggle
                variant="link"
                className="p-0 fw-semibold text-decoration-none text-dark"
                size="sm"
              >
                {filterOptions[filter]}
              </Dropdown.Toggle>
              <Dropdown.Menu>
                {Object.entries(filterOptions).map(([key, label]) => (
                  <Dropdown.Item
                    key={key}
                    active={filter === key}
                    onClick={() => setFilter(key)}
                  >
                    {label}
                  </Dropdown.Item>
                ))}
              </Dropdown.Menu>
            </Dropdown>
          </div>
        </div>

        {/* Post list */}
        {isInitialLoading ? (
          <div className="text-center my-5">
            <Spinner animation="border" variant="primary" />
            <p className="text-muted mt-2">Memuat postingan...</p>
          </div>
        ) : sortedPosts.length === 0 ? (
          <p className="text-muted">Belum ada postingan.</p>
        ) : (
          sortedPosts.map((post) => (
            <div key={post.id} id={`post-${post.id}`}>
              <PostCard
                post={post}
                onDeletePost={handleOpenDeleteModal}
                onEditPost={handleOpenEditModal}
                onEditComment={handleOpenEditComment}
                onPinPost={pinPost}
                onDeleteComment={handleDeleteComment}
                onImageClick={handleOpenImageModal}
                onCommentAdded={handleAddComment}
                onShowToast={showToast}
                currentUserId={1} // ✅ GANTI dengan ID user login
              />
            </div>
          ))
        )}
      </div>

      {/* Kolom kanan: Statistik forum */}
      <div className="col-md-4">
        <ForumStatsCard
          totalPosts={totalPosts}
          postsWithImages={postsWithImages}
          totalPinnedPosts={totalPinnedPosts}
          topPosts={top10Posts}
          totalComments={totalComments} 
        />
      </div>
    </div>

    {/* Modal dan Toast */}
    <PostCreateModal show={showCreateModal} onHide={() => setShowCreateModal(false)} onCreate={handleCreatePost} />
    <PostEditModal show={showEditModal} onHide={() => setShowEditModal(false)} onSave={handleEditPost} initialData={selectedPost} />
    <ConfirmModal show={showDeleteModal} onHide={() => setShowDeleteModal(false)} onConfirm={handleConfirmDelete} title="Hapus Postingan" body="Yakin ingin menghapus postingan ini?" confirmText="Hapus" variant="danger" />
    <CommentEditModal show={showEditCommentModal} onHide={() => setShowEditCommentModal(false)} comment={selectedComment} onSave={handleEditComment} />

    {/* Modal Gambar */}
    <Modal show={showImageModal} onHide={() => setShowImageModal(false)} centered size="xl" className="image-preview-modal">
      <Modal.Header className="border-0 pb-0">
        <button type="button" className="btn-close ms-auto" aria-label="Close" onClick={() => setShowImageModal(false)} />
      </Modal.Header>
      <Modal.Body className="p-0 position-relative">
        <div className="d-flex justify-content-center align-items-center bg-dark" style={{ minHeight: "80vh" }}>
          {imageList.length > 1 && (
            <button onClick={() => setStartIndex((prev) => (prev - 1 + imageList.length) % imageList.length)} className="btn btn-light position-absolute" style={{ left: 20, top: "50%", transform: "translateY(-50%)" }}>‹</button>
          )}
          <img src={`http://localhost:3000/${imageList[startIndex]?.image}`} alt="preview" style={{ maxHeight: "75vh", maxWidth: "100%", objectFit: "contain", borderRadius: "8px" }} onError={handleImageError} />
          {imageList.length > 1 && (
            <button onClick={() => setStartIndex((prev) => (prev + 1) % imageList.length)} className="btn btn-light position-absolute" style={{ right: 20, top: "50%", transform: "translateY(-50%)" }}>›</button>
          )}
        </div>
        <div className="d-flex justify-content-center gap-2 my-3 flex-wrap">
          {imageList.map((img, idx) => (
            <img key={img.id} src={`http://localhost:3000/${img.image}`} alt={`thumb-${idx}`} onClick={() => setStartIndex(idx)} style={{ width: 60, height: 45, objectFit: "cover", cursor: "pointer", border: idx === startIndex ? "2px solid #0d6efd" : "1px solid #ccc", borderRadius: 4 }} onError={handleImageError}/>
          ))}
        </div>
      </Modal.Body>
    </Modal>

    <ToastNotification show={toast.show} onClose={() => setToast({ ...toast, show: false })} message={toast.message} variant={toast.variant} />
  </div>
);

}

export default ForumPage;
