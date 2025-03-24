import { useState } from "react";
import LaporanTable from "./components/LaporanTable";
import DetailLaporanModal from "./components/DetailLaporanModal";
import StatusLaporanModal from "./components/StatusLaporanModal";
import { useReport  } from '../../context/ReportContext';

const LaporanPage = () => {
  const {
    reports,
    getReportById,
    updateReportStatus,
    deleteReport,
    updateReportLocally,
    removeReport,
  } = useReport ();



  const [selectedReport, setSelectedReport] = useState(null);
  const [newStatus, setNewStatus] = useState("");
  const [message, setMessage] = useState("");
  const [showStatusModal, setShowStatusModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);

  const handleOpenDetailModal = async (id) => {
    try {
      const report = await getReportById(id);
      setSelectedReport(report);
      setShowDetailModal(true);
    } catch (error) {
      alert(`Terjadi kesalahan: ${error.message}`);
    }
  };

  const handleOpenStatusModal = (report) => {
    setSelectedReport(report);
    setNewStatus("");
    setShowStatusModal(true);
  };

  const statusHierarchy = [
    "pending",
    "rejected",
    "verified",
    "in_progress",
    "completed",
    "closed",
  ];

  const handleChangeStatus = async () => {
    if (!selectedReport?.id || !newStatus || !message) {
      alert("❌ Harap isi semua field.");
      return;
    }

    if (selectedReport.status === newStatus) {
      alert(`❌ Status sudah berada di '${newStatus}'`);
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
      alert(
        `❌ Tidak bisa ubah dari '${selectedReport.status}' ke '${newStatus}'`
      );
      return;
    }

    try {
      await updateReportStatus(selectedReport.id, {
        new_status: newStatus,
        message,
      });
      alert("✅ Status berhasil diubah!");
      updateReportLocally(selectedReport.id, newStatus);
      setShowStatusModal(false);
    } catch (error) {
      alert(`❌ ${error.message}`);
    }
  };

  const handleDeleteReport = async (id) => {
    if (!window.confirm("Yakin hapus laporan ini?")) return;
    try {
      await deleteReport(id);
      alert("✅ Laporan berhasil dihapus");
      removeReport(id);
    } catch (error) {
      alert(`❌ ${error.message}`);
    }
  };

  return (
    <>
      <LaporanTable
        reports={reports}
        handleOpenDetailModal={handleOpenDetailModal}
        handleOpenStatusModal={handleOpenStatusModal}
        handleDeleteReport={handleDeleteReport} // ✅ ini yang kurang!
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
        statusHierarchy={statusHierarchy}
      />
    </>
  );
};

export default LaporanPage;
