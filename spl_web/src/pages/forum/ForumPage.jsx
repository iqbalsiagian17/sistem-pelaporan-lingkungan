import { useState } from "react";
import { Modal, Carousel, Dropdown, ButtonGroup, Spinner } from "react-bootstrap";
import { usePost } from "../../context/PostContext";
import PostCard from "./components/PostCard";
import PostCreateModal from "./components/PostCreateModal";
import PostEditModal from "./components/PostEditModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import CommentEditModal from "./components/CommentEditModal";
import ToastNotification from "../../components/common/ToastNotification";

const ForumPage = () => {
  const {
    posts,
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

  // Pisahkan pinned dan unpinned posts
  const pinned = posts.filter((p) => p.is_pinned);
  const notPinned = posts.filter((p) => !p.is_pinned);

  let filteredPosts = [...notPinned];
  if (filter === "terbaru") {
    filteredPosts.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  } else if (filter === "populer") {
    filteredPosts.sort((a, b) => b.likes - a.likes);
  }

  const sortedPosts = [...pinned, ...filteredPosts];

  // 🔍 Tampilkan loading jika data belum tersedia
  const isInitialLoading = posts.length === 0 && !toast.show && !showCreateModal && !showEditModal;

  return (
    <div className="container mx-auto px-4 py-4">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <Dropdown as={ButtonGroup}>
          <Dropdown.Toggle variant="outline-secondary">
            Filter: {filter === "terbaru" ? "Terbaru" : "Populer"}
          </Dropdown.Toggle>
          <Dropdown.Menu>
            <Dropdown.Item onClick={() => setFilter("terbaru")}>Terbaru</Dropdown.Item>
            <Dropdown.Item onClick={() => setFilter("populer")}>Populer</Dropdown.Item>
          </Dropdown.Menu>
        </Dropdown>

        <button onClick={() => setShowCreateModal(true)} className="btn btn-primary">
          + Buat Postingan
        </button>
      </div>

      {isInitialLoading ? (
        <div className="text-center my-5">
          <Spinner animation="border" variant="primary" />
          <p className="text-muted mt-2">Memuat postingan...</p>
        </div>
      ) : sortedPosts.length === 0 ? (
        <p className="text-muted">Belum ada postingan.</p>
      ) : (
        sortedPosts.map((post) => (
          <PostCard
            key={post.id}
            post={post}
            onDeletePost={handleOpenDeleteModal}
            onEditPost={handleOpenEditModal}
            onEditComment={handleOpenEditComment}
            onPinPost={pinPost}
            onDeleteComment={handleDeleteComment}
            onImageClick={handleOpenImageModal}
          />
        ))
      )}

      <PostCreateModal show={showCreateModal} onHide={() => setShowCreateModal(false)} onCreate={handleCreatePost} />

      <PostEditModal show={showEditModal} onHide={() => setShowEditModal(false)} onSave={handleEditPost} initialData={selectedPost} />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
        title="Hapus Postingan"
        body="Yakin ingin menghapus postingan ini?"
        confirmText="Hapus"
        variant="danger"
      />

      <CommentEditModal
        show={showEditCommentModal}
        onHide={() => setShowEditCommentModal(false)}
        comment={selectedComment}
        onSave={handleEditComment}
      />

      <Modal show={showImageModal} onHide={() => setShowImageModal(false)} size="lg" centered>
        <Modal.Body className="p-0">
          <Carousel activeIndex={startIndex} onSelect={(i) => setStartIndex(i)} interval={null}>
            {imageList.map((img) => (
              <Carousel.Item key={img.id}>
                <img
                  src={`https://baligebersih.site/${img.image}`}
                  alt="slide"
                  className="d-block w-100"
                  style={{ objectFit: "contain", maxHeight: "80vh" }}
                />
              </Carousel.Item>
            ))}
          </Carousel>
        </Modal.Body>
      </Modal>

      <ToastNotification
        show={toast.show}
        onClose={() => setToast({ ...toast, show: false })}
        message={toast.message}
        variant={toast.variant}
      />
    </div>
  );
};

export default ForumPage;
