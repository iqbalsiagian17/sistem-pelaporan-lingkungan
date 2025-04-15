  import { useState, useEffect } from "react";
  import ParameterTable from "./components/ParameterTable";
  import CreateParameterModal from "./components/CreateParameterModal";
  import EditParameterModal from "./components/EditParameterModal";
  import DetailParameterModal from "./components/DetailParameterModal";
  import ConfirmModal from "../../components/common/ConfirmModal";
  import ToastNotification from "../../components/common/ToastNotification";
  import {
    getAllParameters,
    createParameter,
    updateParameter,
    deleteParameter,
  } from "../../services/parameterService";

  const ParameterPage = () => {
    const [parameters, setParameters] = useState([]);
    const [selectedParameter, setSelectedParameter] = useState(null);
    const [showCreateModal, setShowCreateModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [showDetailModal, setShowDetailModal] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);

    const [toast, setToast] = useState({
      show: false,
      message: "",
      variant: "success",
    });

    const showToast = (message, variant = "success") => {
      setToast({ show: true, message, variant });
    };

    const fetchData = async () => {
      try {
        const result = await getAllParameters();
        setParameters(result);
      } catch (err) {
        alert(`Gagal memuat parameter: ${err.message}`);
      }
    };

    const handleCreate = async (data) => {
      try {
        await createParameter(data);
        setShowCreateModal(false);
        fetchData();
        showToast("Parameter berhasil ditambahkan.");
      } catch (err) {
        alert(`Gagal membuat: ${err.message}`);
      }
    };

    const handleOpenDetailModal = (parameter) => {
      setSelectedParameter(parameter);
      setShowDetailModal(true);
    };

    const handleOpenEditModal = (parameter) => {
      setSelectedParameter(parameter);
      setShowEditModal(true);
    };

    const handleOpenDeleteModal = (parameter) => {
      setSelectedParameter(parameter);
      setShowDeleteModal(true);
    };

    const handleSaveEdit = async (formData) => {
      try {
        await updateParameter(selectedParameter.id, formData);  // ✅ Benar
        setShowEditModal(false);
        fetchData();
        showToast("Parameter berhasil diperbarui.");
      } catch (err) {
        alert(`Gagal memperbarui: ${err.message}`);
      }
    };

    const handleConfirmDelete = async () => {
      try {
        await deleteParameter(selectedParameter.id); // penting: tambahkan ID-nya!
        setShowDeleteModal(false);
        fetchData();
        showToast("Parameter berhasil dihapus.", "danger");
      } catch (err) {
        alert(`Gagal menghapus: ${err.message}`);
      }
    };

    useEffect(() => {
      fetchData();
    }, []);

    return (
      <>
        {parameters.length === 0 && (
          <div className="d-flex justify-content-end mb-3">
            <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>
              + Tambah Parameter
            </button>
          </div>
        )}

        <ParameterTable
          parameters={parameters}
          onView={handleOpenDetailModal}
          onEdit={handleOpenEditModal}
          onDelete={handleOpenDeleteModal}
        />

        <CreateParameterModal
          show={showCreateModal}
          onHide={() => setShowCreateModal(false)}
          onCreate={handleCreate}
        />

        <EditParameterModal
          show={showEditModal}
          onHide={() => setShowEditModal(false)}
          parameter={selectedParameter}
          onSave={handleSaveEdit}
        />

        <ConfirmModal
          show={showDeleteModal}
          onHide={() => setShowDeleteModal(false)}
          onConfirm={handleConfirmDelete}
          title="🗑️ Hapus Parameter"
          body={`Yakin ingin menghapus parameter ini?`}
          confirmText="Hapus"
          variant="danger"
        />

        <DetailParameterModal
          show={showDetailModal}
          onHide={() => setShowDetailModal(false)}
          parameter={selectedParameter}
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

  export default ParameterPage;
