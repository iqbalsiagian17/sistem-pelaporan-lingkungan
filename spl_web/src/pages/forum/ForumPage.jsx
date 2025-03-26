import { useState } from "react";
import { Modal, Carousel, Dropdown, ButtonGroup } from "react-bootstrap";
import { usePost } from "../../context/PostContext";
import PostCard from "./components/PostCard";
import PostCreateModal from "./components/PostCreateModal";
import ConfirmModal from "../../components/common/ConfirmModal";

const ForumPage = () => {
  const { posts, addPost, removePost, removeComment, pinPost } = usePost();

  const [selectedPost, setSelectedPost] = useState(null);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [filter, setFilter] = useState("terbaru");
  const [showImageModal, setShowImageModal] = useState(false);
  const [startIndex, setStartIndex] = useState(0);
  const [imageList, setImageList] = useState([]);

  const handleOpenImageModal = (images, index) => {
    setImageList(images);
    setStartIndex(index);
    setShowImageModal(true);
  };

  const handleOpenDeleteModal = (post) => {
    setSelectedPost(post);
    setShowDeleteModal(true);
  };

  const handleConfirmDelete = async () => {
    try {
      await removePost(selectedPost.id);
      setShowDeleteModal(false);
    } catch (err) {
      alert(`❌ Gagal menghapus: ${err.message}`);
    }
  };

  const handleDeleteComment = async (commentId) => {
    try {
      await removeComment(commentId);
    } catch (err) {
      alert(`❌ Gagal hapus komentar: ${err.message}`);
    }
  };

  const handleCreatePost = async (formData) => {
    try {
      await addPost(formData);
      setShowCreateModal(false);
    } catch (err) {
      alert(`❌ Gagal menambahkan post: ${err.message}`);
    }
  };

  const pinned = posts.filter((p) => p.is_pinned);
  const notPinned = posts.filter((p) => !p.is_pinned);

  let filteredPosts = [...notPinned];

  if (filter === "terbaru") {
    filteredPosts = filteredPosts.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  } else if (filter === "populer") {
    filteredPosts = filteredPosts.sort((a, b) => b.likes - a.likes);
  }
  
  
  const sortedPosts = [...pinned, ...filteredPosts];

  return (
    <div className="container mx-auto px-4 py-4">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <Dropdown as={ButtonGroup}>
          <Dropdown.Toggle variant="outline-secondary" size="">
            Filter: {filter === "terbaru" ? "Terbaru" :
                    filter === "populer" ? "Populer" :
                    filter === "admin" ? "Postingan Admin" : "Postingan Masyarakat"}
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

      {sortedPosts.length === 0 ? (
        <p className="text-muted">Belum ada postingan.</p>
      ) : (
        sortedPosts.map((post) => (
          <PostCard
            key={post.id}
            post={post}
            onDeletePost={handleOpenDeleteModal}
            onPinPost={pinPost}
            onDeleteComment={handleDeleteComment}
            onImageClick={handleOpenImageModal}
          />
        ))
      )}

      <PostCreateModal
        show={showCreateModal}
        onHide={() => setShowCreateModal(false)}
        onCreate={handleCreatePost}
      />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
        title="🗑️ Hapus Postingan"
        body="Yakin ingin menghapus postingan ini?"
        confirmText="Hapus"
        variant="danger"
      />

      <Modal show={showImageModal} onHide={() => setShowImageModal(false)} size="lg" centered>
        <Modal.Body className="p-0">
          <Carousel activeIndex={startIndex} onSelect={(i) => setStartIndex(i)} interval={null}>
            {imageList.map((img) => (
              <Carousel.Item key={img.id}>
                <img
                  src={`http://localhost:3000/${img.image}`}
                  alt="slide"
                  className="d-block w-100"
                  style={{ objectFit: "contain", maxHeight: "80vh" }}
                />
              </Carousel.Item>
            ))}
          </Carousel>
        </Modal.Body>
      </Modal>
    </div>
  );
};

export default ForumPage;
