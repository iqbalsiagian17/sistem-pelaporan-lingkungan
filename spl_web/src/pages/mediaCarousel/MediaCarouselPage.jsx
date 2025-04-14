import { useState } from "react";
import MediaCarouselTable from "./components/MediaCarouselTable";
import CreateMediaCarouselModal from "./components/CreateMediaCarouselModal";
import EditMediaCarouselModal from "./components/EditMediaCarouselModal";
import DetailMediaCarouselModal from "./components/DetailMediaCarouselModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import ToastNotification from "../../components/common/ToastNotification";
import { useMediaCarousel } from "../../context/MediaCarouselContext";

const MediaCarouselPage = () => {
  const {
    mediaCarousels,
    getMediaCarouselById,
    addMediaCarousel,
    updateMediaCarousel,
    deleteMediaCarousel,
  } = useMediaCarousel();

  const [selectedMediaCarousel, setSelectedMediaCarousel] = useState(null);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [toast, setToast] = useState({
    show: false,
    message: "",
    variant: "success",
  });

  const triggerToast = (message, variant = "success") => {
    setToast({
      show: true,
      message,
      variant,
    });
  };

  const handleOpenDetailModal = async (id) => {
    try {
      const data = await getMediaCarouselById(id);
      setSelectedMediaCarousel(data);
      setShowDetailModal(true);
    } catch (err) {
      alert(`Gagal memuat detail: ${err.message}`);
    }
  };

  const handleOpenEditModal = (item) => {
    setSelectedMediaCarousel(item);
    setShowEditModal(true);
  };

  const handleOpenDeleteModal = (item) => {
    setSelectedMediaCarousel(item);
    setShowDeleteModal(true);
  };

  const handleCreate = async (formData) => {
    try {
      await addMediaCarousel(formData);
      setShowCreateModal(false);
      triggerToast("Media carousel berhasil ditambahkan.");
    } catch (err) {
      alert(`Gagal menambahkan: ${err.message}`);
    }
  };

  const handleSaveEdit = async (id, formData) => {
    try {
      await updateMediaCarousel(id, formData);
      setShowEditModal(false);
      triggerToast("Media carousel berhasil diperbarui.");
    } catch (err) {
      alert(`Gagal mengubah data: ${err.message}`);
    }
  };

  const handleConfirmDelete = async () => {
    try {
      await deleteMediaCarousel(selectedMediaCarousel.id);
      setShowDeleteModal(false);
      triggerToast("Media carousel berhasil dihapus.", "danger");
    } catch (err) {
      alert(`Gagal menghapus: ${err.message}`);
    }
  };

  return (
    <>
      <div className="d-flex justify-content-end mb-3">
        <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>
          + Tambah Media Carousel
        </button>
      </div>

      <MediaCarouselTable
        mediaCarousels={mediaCarousels}
        onView={handleOpenDetailModal}
        onEdit={handleOpenEditModal}
        onDelete={handleOpenDeleteModal}
      />

      <CreateMediaCarouselModal
        show={showCreateModal}
        onHide={() => setShowCreateModal(false)}
        onCreate={handleCreate}
      />

      <EditMediaCarouselModal
        show={showEditModal}
        onHide={() => setShowEditModal(false)}
        mediaCarousel={selectedMediaCarousel}
        onSave={handleSaveEdit}
      />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
        title="Hapus Media Carousel"
        body={`Yakin ingin menghapus media carousel "${selectedMediaCarousel?.title}"?`}
        confirmText="Hapus"
        variant="danger"
      />

      <DetailMediaCarouselModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        mediaCarousel={selectedMediaCarousel}
      />

      <ToastNotification
        show={toast.show}
        onClose={() => setToast({ ...toast, show: false })}
        message={toast.message}
        variant={toast.variant}
      />
    </>
  );
};

export default MediaCarouselPage;
