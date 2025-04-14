import { useState } from "react";
import AnnouncementTable from "./components/AnnouncementTable";
import DetailAnnouncementModal from "./components/DetailAnnouncementModal";
import EditAnnouncementModal from "./components/EditAnnouncementModal";
import DeleteAnnouncementModal from "./components/DeleteAnnouncementModal";
import AnnouncementCreateModal from "./components/CreateAnnouncementModal";
import { useAnnouncement } from "../../context/AnnouncementContext";
import ToastNotification from "../../components/common/ToastNotification";

const AnnouncementPage = () => {
  const {
    announcements,
    getAnnouncementById,
    deleteAnnouncement,
    updateAnnouncement,
    updateAnnouncementLocal,
    addAnnouncement,
  } = useAnnouncement();

  const [selectedAnnouncement, setSelectedAnnouncement] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);

  const [toast, setToast] = useState({
    show: false,
    message: "",
    variant: "success",
  });

  const showToast = (message, variant = "success") => {
    setToast({ show: true, message, variant });
  };

  const handleOpenDetailModal = async (id) => {
    try {
      const announcement = await getAnnouncementById(id);
      setSelectedAnnouncement(announcement);
      setShowDetailModal(true);
    } catch (error) {
      alert(`Gagal memuat detail: ${error.message}`);
    }
  };

  const handleOpenEditModal = (announcement) => {
    setSelectedAnnouncement(announcement);
    setShowEditModal(true);
  };

  const handleOpenDeleteModal = (announcement) => {
    setSelectedAnnouncement(announcement);
    setShowDeleteModal(true);
  };

  const handleCreate = async (data) => {
    try {
      await addAnnouncement(data);
      setShowCreateModal(false);
      showToast("Pengumuman berhasil dibuat.");
    } catch (error) {
      alert(`Gagal membuat pengumuman: ${error.message}`);
    }
  };

  const handleConfirmDelete = async () => {
    if (!selectedAnnouncement?.id) return;

    try {
      await deleteAnnouncement(selectedAnnouncement.id);
      setShowDeleteModal(false);
      showToast("Pengumuman berhasil dihapus.", "danger");
    } catch (error) {
      alert(`Gagal hapus: ${error.message}`);
    }
  };

  const handleSaveEdit = async (id, data) => {
    try {
      const updated = await updateAnnouncement(id, data);
      updateAnnouncementLocal(id, updated);
      setShowEditModal(false);
      showToast("Pengumuman berhasil diperbarui.");
    } catch (error) {
      alert(`Gagal update: ${error.message}`);
    }
  };

  return (
    <>
      <div className="d-flex justify-content-end align-items-center mb-3">
        <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>
          + Buat Pengumuman
        </button>
      </div>

      <AnnouncementTable
        announcements={announcements}
        onView={handleOpenDetailModal}
        onEdit={handleOpenEditModal}
        onDelete={handleOpenDeleteModal}
      />

      <DetailAnnouncementModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        announcement={selectedAnnouncement}
      />

      <AnnouncementCreateModal
        show={showCreateModal}
        onHide={() => setShowCreateModal(false)}
        onCreate={handleCreate}
      />

      <EditAnnouncementModal
        show={showEditModal}
        onHide={() => setShowEditModal(false)}
        announcement={selectedAnnouncement}
        onSave={handleSaveEdit}
      />

      <DeleteAnnouncementModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
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

export default AnnouncementPage;
