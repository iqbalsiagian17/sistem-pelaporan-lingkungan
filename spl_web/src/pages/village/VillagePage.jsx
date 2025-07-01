import { useState } from "react";
import VillageTable from "./components/VillageTable";
import CreateVillageModal from "./components/CreateVillageModal";
import DetailVillageModal from "./components/DetailVillageModal";
import EditVillageModal from "./components/EditVillageModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import ToastNotification from "../../components/common/ToastNotification";
import CustomPagination from "../../components/common/CustomPagination";
import { useVillage } from "../../context/VillageContext";

const VillagePage = () => {
  const {
    villages,
    getVillageById,
    addVillage,
    updateVillageById,
    deleteVillageById,
    isLoading,
  } = useVillage();

  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const villagesPerPage = 10;

  const filteredVillages = villages.filter((v) =>
    v.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const indexOfLast = currentPage * villagesPerPage;
  const indexOfFirst = indexOfLast - villagesPerPage;
  const currentVillages = filteredVillages.slice(indexOfFirst, indexOfLast);

  const totalPages = Math.ceil(filteredVillages.length / villagesPerPage);

  
  const [selectedVillage, setSelectedVillage] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [toast, setToast] = useState({ show: false, message: "", variant: "success" });

  const triggerToast = (message, variant = "success") => {
    setToast({ show: true, message, variant });
  };

  const handleOpenEditModal = (item) => {
    setSelectedVillage(item);
    setShowEditModal(true);
  };

  const handleOpenDeleteModal = (item) => {
    setSelectedVillage(item);
    setShowDeleteModal(true);
  };

  const handleOpenDetailModal = async (id) => {
    try {
      const data = await getVillageById(id);
      setSelectedVillage(data);
      setShowDetailModal(true);
    } catch (err) {
      alert(`Gagal mengambil detail desa: ${err.message}`);
    }
  };

  const handleCreate = async (formData) => {
    try {
      await addVillage(formData);
      setShowCreateModal(false);
      triggerToast("Desa berhasil ditambahkan.");
    } catch (err) {
      alert(`Gagal menambahkan desa: ${err.message}`);
    }
  };

  const handleSaveEdit = async (id, formData) => {
    try {
      await updateVillageById(id, formData);
      setShowEditModal(false);
      triggerToast("Desa berhasil diperbarui.");
    } catch (err) {
      alert(`Gagal mengubah desa: ${err.message}`);
    }
  };

  const handleConfirmDelete = async () => {
    try {
      await deleteVillageById(selectedVillage.id);
      setShowDeleteModal(false);
      triggerToast("Desa berhasil dihapus.", "danger");
    } catch (err) {
      alert(`Gagal menghapus desa: ${err.message}`);
    }
  };

  return (
    <>
      <div className="d-flex justify-content-end align-items-center mb-3">
        <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>
          + Tambah Desa
        </button>
      </div>

      <VillageTable
        villages={currentVillages}
        isLoading={isLoading}
        onView={handleOpenDetailModal}
        onEdit={handleOpenEditModal}
        onDelete={handleOpenDeleteModal}
        currentPage={currentPage}
        totalPages={totalPages}
        setCurrentPage={setCurrentPage}
        search={searchQuery}              // ✅ ganti
        setSearch={setSearchQuery}        // ✅ ganti
      />

     

      <DetailVillageModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        village={selectedVillage}
      />

      <CreateVillageModal
        show={showCreateModal}
        onHide={() => setShowCreateModal(false)}
        onCreate={handleCreate}
      />

      <EditVillageModal
        show={showEditModal}
        onHide={() => setShowEditModal(false)}
        village={selectedVillage}
        onSave={handleSaveEdit}
      />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={handleConfirmDelete}
        title="Hapus Desa"
        body={`Yakin ingin menghapus desa "${selectedVillage?.name}"?`}
        confirmText="Hapus"
        variant="danger"
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

export default VillagePage;
