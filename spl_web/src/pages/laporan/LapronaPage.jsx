import { useState } from "react";
import LaporanTable from "./components/LaporanTable";
import DetailLaporanModal from "./components/DetailLaporanModal";
import StatusLaporanModal from "./components/StatusLaporanModal";
import ConfirmModal from "../../components/common/ConfirmModal";
import { useReport } from '../../context/ReportContext';
import ToastNotification from "../../components/common/ToastNotification";

const LaporanPage = () => {
  const {
    reports,
    getReportById,
    updateReportStatus,
    deleteReport,
    updateReportLocally,
    removeReport,
  } = useReport();

  const [selectedReport, setSelectedReport] = useState(null);
  const [newStatus, setNewStatus] = useState("");
  const [message, setMessage] = useState("");
  const [showStatusModal, setShowStatusModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [reportToDelete, setReportToDelete] = useState(null);

  const [toast, setToast] = useState({ show: false, message: "", variant: "success" });
  const showToast = (msg, variant = "success") => {
    setToast({ show: true, message: msg, variant });
  };

  const handleOpenDetailModal = async (id) => {
    try {
      const report = await getReportById(id);
      setSelectedReport(report);
      setShowDetailModal(true);
    } catch (error) {
      showToast(`Terjadi kesalahan: ${error.message}`);
    }
  };

  const handleOpenStatusModal = (report) => {
    setSelectedReport(report);
    setNewStatus("");
    setShowStatusModal(true);
  };

  const handleChangeStatus = async (evidences = []) => {
    if (!selectedReport?.id || !newStatus || !message) {
      showToast("Harap isi semua field.");
      return;
    }

    if (selectedReport.status === newStatus) {
      showToast(`Status sudah berada di '${newStatus}'`);
      return;
    }

    const allowed = {
      pending: ["verified", "rejected"],
      verified: ["in_progress"],
      in_progress: ["completed"],
      completed: ["closed"],
      rejected: [],
      closed: [],
    };

    if (!allowed[selectedReport.status]?.includes(newStatus)) {
      showToast(`Tidak bisa ubah dari '${selectedReport.status}' ke '${newStatus}'`);
      return;
    }

    try {
      await updateReportStatus(selectedReport.id, {
        new_status: newStatus,
        message,
      }, evidences);
      updateReportLocally(selectedReport.id, newStatus);
      showToast("Status berhasil diubah!");
      setShowStatusModal(false);
    } catch (error) {
      showToast(`❌ ${error.message}`);
    }
  };

  const handleDeleteReport = (reportId) => {
    const report = reports.find(r => r.id === reportId);
    setReportToDelete(report);
    setShowDeleteModal(true);
  };

  const confirmDeleteReport = async () => {
    if (!reportToDelete) return;

    try {
      await deleteReport(reportToDelete.id);
      showToast("Laporan berhasil dihapus");
      removeReport(reportToDelete.id);
    } catch (error) {
      showToast(`❌ ${error.message}`);
    } finally {
      setShowDeleteModal(false);
      setReportToDelete(null);
    }
  };

  return (
    <>
      <LaporanTable
        reports={reports}
        handleOpenDetailModal={handleOpenDetailModal}
        handleOpenStatusModal={handleOpenStatusModal}
        handleDeleteReport={handleDeleteReport}
      />

      <DetailLaporanModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        report={selectedReport}
      />

      <StatusLaporanModal
        show={showStatusModal}
        onHide={() => setShowStatusModal(false)}
        selectedReport={selectedReport}
        newStatus={newStatus}
        setNewStatus={setNewStatus}
        message={message}
        setMessage={setMessage}
        handleChangeStatus={handleChangeStatus}
      />

      <ConfirmModal
        show={showDeleteModal}
        onHide={() => setShowDeleteModal(false)}
        onConfirm={confirmDeleteReport}
        title="Hapus Laporan"
        body={`Yakin ingin menghapus laporan "${reportToDelete?.report_number}"?`}
        confirmText="Hapus"
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

export default LaporanPage;
