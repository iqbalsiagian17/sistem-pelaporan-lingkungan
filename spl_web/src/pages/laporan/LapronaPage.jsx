import { useEffect, useState } from "react";
import LaporanTable from "./components/LaporanTable";
import DetailLaporanModal from "./components/DetailLaporanModal";
import StatusLaporanModal from "./components/StatusLaporanModal";

const LaporanPage = () => {
    const [reports, setReports] = useState([]); // State laporan
    const [selectedReport, setSelectedReport] = useState(null); // Laporan terpilih
    const [newStatus, setNewStatus] = useState(""); // Status baru
    const [message, setMessage] = useState(""); // Pesan perubahan status
    const [showStatusModal, setShowStatusModal] = useState(false);
    const [showDetailModal, setShowDetailModal] = useState(false);
    const [loading, setLoading] = useState(true); // ✅ Tambahkan state loading

    // ✅ Fetch laporan dari backend saat pertama kali komponen dimuat
    useEffect(() => {
        fetchReports();
    }, []);

    // ✅ Fungsi untuk mengambil laporan
    const fetchReports = async () => {
        setLoading(true); // Pastikan loading dimulai
        
        try {
            const token = localStorage.getItem("accessToken");
            
            if (!token) {
                console.error("❌ Token tidak ditemukan! Silakan login ulang.");
                setLoading(false); // Hindari infinite loading
                return;
            }

            console.log("🔑 Token yang dikirim:", token); // Debugging token

            const response = await fetch("http://localhost:3000/api/admin/reports", {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}` // Pastikan formatnya benar
                }
            });

            console.log("🔄 Response Status:", response.status); // Lihat status response

            if (!response.ok) {
                const errorData = await response.json();
                console.error("❌ Error dari server:", errorData);
                throw new Error(`Error ${response.status}: ${errorData.message}`);
            }

            const data = await response.json();
            console.log("✅ Data laporan dari API:", data);
            setReports(data.reports || []); // Pastikan data adalah array

        } catch (error) {
            console.error("⚠️ Error fetching reports:", error.message);
            setReports([]); // Jika terjadi error, set array kosong
        } finally {
            setLoading(false); // ✅ Hindari infinite loading
        }
    };

    // ✅ Buka modal detail laporan
    const handleOpenDetailModal = async (id) => {
      try {
          const response = await fetch(`http://localhost:3000/api/admin/reports/${id}`, {
              headers: { Authorization: `Bearer ${localStorage.getItem("accessToken")}` }
          });
  
          if (!response.ok) throw new Error("Gagal mengambil detail laporan.");
  
          const { report } = await response.json();
          console.log("📝 Detail laporan:", report); // Debugging
  
          setSelectedReport(report);
          setShowDetailModal(true);
      } catch (error) {
          alert(`Terjadi kesalahan: ${error.message}`);
      }
  };
  
  
  
  

      // ✅ Buka modal ubah status
      const handleOpenStatusModal = (report) => {
        setSelectedReport(report);
        setNewStatus(""); // ✅ Kosongkan dulu agar user harus memilih status baru
        setShowStatusModal(true);
    };
    

      // ✅ Ubah status laporan
      const statusHierarchy = [
        "pending",
        "rejected",
        "verified",
        "in_progress",
        "completed",
        "closed"
    ];
    
    const handleChangeStatus = async () => {
      if (!selectedReport?.id) {
          alert("❌ ID laporan tidak valid!");
          return;
      }

      if (!newStatus || !message) {
          alert("❌ Harap isi status baru dan pesan.");
          return;
      }

      // ✅ Cek jika status tidak berubah
      if (selectedReport.status === newStatus) {
          alert(`❌ Status sudah berada di '${newStatus}', pilih status lain.`);
          return;
      }

      // ✅ Flow perubahan status yang diperbolehkan
      const allowedTransitions = {
          "pending": ["verified", "rejected"],
          "verified": ["in_progress"],
          "in_progress": ["completed"],
          "completed": ["closed"],
          "rejected": [], // Tidak bisa diubah lagi
          "closed": [] // Tidak bisa diubah lagi
      };

      // ✅ Pastikan status baru ada dalam daftar yang diperbolehkan
      const nextStatuses = allowedTransitions[selectedReport.status] || [];

      if (!nextStatuses.includes(newStatus)) {
          alert(`❌ Status tidak bisa diubah langsung dari '${selectedReport.status}' ke '${newStatus}'!`);
          return;
      }

      const requestBody = JSON.stringify({ new_status: newStatus, message });
      console.log("📤 Data yang dikirim ke API:", requestBody);

      try {
          const response = await fetch(`http://localhost:3000/api/admin/reports/${selectedReport.id}/status`, {
              method: "PUT",
              headers: {
                  "Content-Type": "application/json",
                  Authorization: `Bearer ${localStorage.getItem("accessToken")}`
              },
              body: requestBody
          });

          console.log("🔄 Response Status:", response.status);

          const responseData = await response.json();
          console.log("📥 Response dari API:", responseData);

          if (response.ok) {
              alert("✅ Status berhasil diubah!");
              setReports((prev) =>
                  prev.map((report) =>
                      report.id === selectedReport.id ? { ...report, status: newStatus } : report
                  )
              );
              setShowStatusModal(false);
          } else {
              alert(`❌ Gagal mengubah status: ${responseData.message || "Terjadi kesalahan"}`);
          }
      } catch (error) {
          alert("❌ Terjadi kesalahan saat mengubah status.");
          console.error("Error updating status:", error);
      }
  };





  

    // ✅ Hapus laporan
    const handleDeleteReport = async (id) => {
        if (!window.confirm("Apakah Anda yakin ingin menghapus laporan ini?")) return;

        const response = await fetch(`http://localhost:3000/api/admin/reports/${id}`, {
            method: "DELETE",
            headers: {
                Authorization: `Bearer ${localStorage.getItem("accessToken")}`
            }
        });

        if (response.ok) {
            alert("Laporan berhasil dihapus!");
            setReports(reports.filter((report) => report.id !== id));
        } else {
            alert("Gagal menghapus laporan.");
        }
    };

    return (
        <>
            <LaporanTable
                reports={reports}
                handleOpenDetailModal={handleOpenDetailModal}
                handleOpenStatusModal={handleOpenStatusModal}
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
                handleChangeStatus={handleChangeStatus} // ✅ Pastikan diteruskan sebagai prop
                statusHierarchy={statusHierarchy}
            />
        </>
    );
};

export default LaporanPage;
