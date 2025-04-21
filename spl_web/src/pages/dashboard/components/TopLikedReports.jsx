const TopLikedReports = ({ filteredTopReports, filter, setFilter, translateStatus, getStatusColor, handleOpenDetailModal }) => (
  <div className="card">
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
          {filteredTopReports.length === 0 ? (
            <tr>
              <td colSpan="4" className="text-center text-muted">Tidak ada laporan ditemukan.</td>
            </tr>
          ) : (
            filteredTopReports.map((report, index) => (
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

export default TopLikedReports;
