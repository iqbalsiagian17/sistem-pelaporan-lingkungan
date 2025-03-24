import { createContext, useContext, useEffect, useState } from "react";
import {
  getAllReports,
  getReportById,
  updateReportStatus,
  deleteReport
} from "../services/reportService";

// 1. Buat context
const ReportContext = createContext();

// 2. Custom hook untuk akses context
export const useReport = () => useContext(ReportContext);

// 3. Provider
export const ReportProvider = ({ children }) => {
  const [reports, setReports] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchReports = async () => {
    setLoading(true);
    try {
      const data = await getAllReports();
      setReports(data);
    } catch (err) {
      console.error("❌ Gagal mengambil laporan:", err.message);
      setReports([]);
    } finally {
      setLoading(false);
    }
  };

  const updateReportLocally = (id, newStatus) => {
    setReports((prev) =>
      prev.map((report) =>
        report.id === id ? { ...report, status: newStatus } : report
      )
    );
  };

  const removeReport = (id) => {
    setReports((prev) => prev.filter((r) => r.id !== id));
  };

  useEffect(() => {
    fetchReports();
  }, []);

  return (
    <ReportContext.Provider
      value={{
        reports,
        loading,
        fetchReports,
        getReportById,
        updateReportStatus,
        deleteReport,
        updateReportLocally,
        removeReport
      }}
    >
      {children}
    </ReportContext.Provider>
  );
};
