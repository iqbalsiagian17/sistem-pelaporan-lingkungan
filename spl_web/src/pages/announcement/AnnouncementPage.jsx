import { useEffect, useState } from "react";
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
    fetchAnnouncements,
  } = useAnnouncement();

  const [selectedAnnouncement, setSelectedAnnouncement] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  const [toast, setToast] = useState({
    show: false,
    message: "",
    variant: "success",
  });

  const showToast = (message, variant = "success") => {
    setToast({ show: true, message, variant });
  };

useEffect(() => {
  const loadAnnouncements = async () => {
    setIsLoading(true);
    try {
      await fetchAnnouncements();
    } catch (err) {
      showToast("Gagal memuat pengumuman", "danger");
      return; // ⛔ keluar sebelum isLoading = false
    }
    setIsLoading(false); // ✅ hanya diset kalau berhasil
  };
  loadAnnouncements();
}, []);


  const handleOpenDetailModal = async (id) => {
    try {
      const announcement = await getAnnouncementById(id);
      setSelectedAnnouncement(announcement);
      setShowDetailModal(true);
    } catch (error) {
      showToast(`Gagal memuat detail: ${error.message}`, "danger");
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
      showToast(`Gagal membuat pengumuman: ${error.message}`, "danger");
    }
  };

  const handleConfirmDelete = async () => {
    if (!selectedAnnouncement?.id) return;
    try {
      await deleteAnnouncement(selectedAnnouncement.id);
      setShowDeleteModal(false);
      showToast("Pengumuman berhasil dihapus.", "danger");
    } catch (error) {
      showToast(`Gagal hapus: ${error.message}`, "danger");
    }
  };

  const handleSaveEdit = async (id, data) => {
    try {
      const updated = await updateAnnouncement(id, data);
      updateAnnouncementLocal(id, updated);
      setShowEditModal(false);
      showToast("Pengumuman berhasil diperbarui.");
    } catch (error) {
      showToast(`Gagal update: ${error.message}`, "danger");
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
        isLoading={isLoading}
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
