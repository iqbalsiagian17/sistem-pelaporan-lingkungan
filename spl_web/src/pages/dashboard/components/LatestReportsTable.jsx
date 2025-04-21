const LatestReportsTable = ({ latestReports, handleOpenDetailModal }) => (
  <div className="card">
    <div className="card-header pb-2">
      <h5 className="mb-1">Laporan Terbaru</h5>
      <small className="text-muted">5 laporan terbaru yang baru masuk</small>
    </div>
    <div className="table-responsive text-nowrap">
      <table className="table table-hover">
        <thead className="table-light">
          <tr>
            <th>Nomor</th>
            <th>Pelapor</th>
            <th>Judul</th>
            <th>Tanggal</th>
          </tr>
        </thead>
        <tbody>
          {latestReports.length === 0 ? (
            <tr>
              <td colSpan="4" className="text-center text-muted">Belum ada laporan baru.</td>
            </tr>
          ) : (
            latestReports.map((report, index) => (
              <tr key={index}>
                {/* 🔥 Nomor laporan bisa diklik */}
                <td>
                  <button
                    className="btn btn-link p-0 fw-bold text-decoration-none"
                    style={{ color: "#696CFF" }}
                    onClick={() => handleOpenDetailModal(report)}
                  >
                    {report.report_number}
                  </button>
                </td>
                <td>{report.user?.username || "-"}</td>
                <td className="fw-medium">{report.title}</td>
                <td>{new Date(report.createdAt).toLocaleString("id-ID")}</td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  </div>
);

export default LatestReportsTable;
