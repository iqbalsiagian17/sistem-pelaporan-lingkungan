import React from "react";

// Fungsi helper untuk mengatur warna status
const getStatusColor = (status) => {
  switch (status) {
    case "pending":
      return "warning";
    case "verified":
      return "info";
    case "in_progress":
      return "primary";
    case "completed":
      return "success";
    case "closed":
      return "secondary";
    case "rejected":
      return "danger";
    default:
      return "secondary";
  }
};

const LatestReportsTable = ({ latestReports, handleOpenDetailModal }) => (
  <div className="card">
    <h5 className="card-header">Laporan Terbaru</h5>
    <div className="table-responsive text-nowrap">
      <table className="table table-hover">
        <thead className="table-light">
          <tr>
            <th>Nomor</th>
            <th>Pelapor</th>
            <th>Judul</th>
            <th>Status</th>
            <th>Tanggal</th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody className="table-border-bottom-0">
          {latestReports.length === 0 ? (
            <tr>
              <td colSpan="6" className="text-center text-muted">
                Belum ada laporan baru.
              </td>
            </tr>
          ) : (
            latestReports.map((report, index) => {
              const username = report.user?.username || "Pengguna";
              const avatarUrl = report.user?.avatar
                ? `http://localhost:3000/${report.user.avatar}`
                : `https://ui-avatars.com/api/?name=${encodeURIComponent(username)}&background=198754&color=fff`;

              return (
                <tr key={index}>
                  <td>
                    <button
                      className="btn btn-link p-0 fw-bold text-decoration-none"
                      style={{ color: "#696CFF" }}
                      onClick={() => handleOpenDetailModal(report)}
                    >
                      {report.report_number}
                    </button>
                  </td>
                  <td className="d-flex align-items-center">
                    <img
                      src={avatarUrl}
                      alt={`Avatar ${username}`}
                      className="rounded-circle me-2"
                      width="28"
                      height="28"
                      style={{ objectFit: "cover" }}
                    />
                    {username}
                  </td>
                  <td className="fw-medium">{report.title}</td>
                  <td>
                    <span className={`badge bg-label-${getStatusColor(report.status)} me-1`}>
                      {report.status.replace("_", " ").toUpperCase()}
                    </span>
                  </td>
                  <td>{new Date(report.createdAt).toLocaleString("id-ID")}</td>
                  <td>
                    <div className="dropdown">
                      <button
                        type="button"
                        className="btn p-0 dropdown-toggle hide-arrow"
                        data-bs-toggle="dropdown"
                      >
                        <i className="bx bx-dots-vertical-rounded"></i>
                      </button>
                      <div className="dropdown-menu">
                        <button
                          className="dropdown-item"
                          onClick={() => handleOpenDetailModal(report)}
                        >
                          <i className="bx bx-show me-2"></i> Lihat
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              );
            })
          )}
        </tbody>
      </table>
    </div>
  </div>
);

export default LatestReportsTable;
