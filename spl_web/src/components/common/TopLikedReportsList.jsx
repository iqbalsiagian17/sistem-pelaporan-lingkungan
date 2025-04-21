import { useState, useMemo } from "react";

const TopLikedReportsList = ({ reports }) => {
  const [filter, setFilter] = useState("all"); // all, ongoing, completed

  const filteredReports = useMemo(() => {
    if (!reports || reports.length === 0) return [];

    return reports
      .filter((report) => {
        if (filter === "completed") {
          return report.status === "completed" || report.status === "closed";
        }
        if (filter === "ongoing") {
          return report.status === "verified" || report.status === "in_progress";
        }
        return true; // all
      })
      .sort((a, b) => (b.total_likes || 0) - (a.total_likes || 0)) // urutkan dari paling banyak like
      .slice(0, 5); // ambil top 5
  }, [reports, filter]);

  return (
    <div className="card mb-4">
      <div className="card-header d-flex justify-content-between align-items-center">
        <h5 className="mb-0">Top 5 Dukungan Laporan</h5>
        <div className="btn-group">
          <button
            className={`btn btn-sm ${filter === "all" ? "btn-primary" : "btn-outline-primary"}`}
            onClick={() => setFilter("all")}
          >
            Semua
          </button>
          <button
            className={`btn btn-sm ${filter === "ongoing" ? "btn-primary" : "btn-outline-primary"}`}
            onClick={() => setFilter("ongoing")}
          >
            Sedang Proses
          </button>
          <button
            className={`btn btn-sm ${filter === "completed" ? "btn-primary" : "btn-outline-primary"}`}
            onClick={() => setFilter("completed")}
          >
            Selesai
          </button>
        </div>
      </div>
      <div className="table-responsive text-nowrap">
        <table className="table table-hover">
          <thead className="table-light">
            <tr>
              <th>Nomor</th>
              <th>Judul</th>
              <th>Dukungan</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {filteredReports.length === 0 ? (
              <tr>
                <td colSpan="4" className="text-center text-muted">
                  Tidak ada laporan ditemukan.
                </td>
              </tr>
            ) : (
              filteredReports.map((report, index) => (
                <tr key={index}>
                  <td>{report.report_number}</td>
                  <td className="fw-medium">{report.title}</td>
                  <td>{report.total_likes}</td>
                  <td>
                    <span className={`badge bg-label-${getStatusColor(report.status)}`}>
                      {translateStatus(report.status)}
                    </span>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

// Helper untuk translate status ke teks lebih rapi
const translateStatus = (status) => {
  switch (status) {
    case "pending":
      return "Menunggu";
    case "verified":
      return "Terverifikasi";
    case "in_progress":
      return "Sedang Diproses";
    case "completed":
      return "Selesai";
    case "closed":
      return "Ditutup";
    case "rejected":
      return "Ditolak";
    case "cancelled":
      return "Dibatalkan";
    default:
      return status;
  }
};

// Helper untuk badge color
const getStatusColor = (status) => {
  switch (status) {
    case "completed":
    case "closed":
      return "success";
    case "verified":
    case "in_progress":
      return "warning";
    case "rejected":
    case "cancelled":
      return "danger";
    default:
      return "secondary";
  }
};

export default TopLikedReportsList;
