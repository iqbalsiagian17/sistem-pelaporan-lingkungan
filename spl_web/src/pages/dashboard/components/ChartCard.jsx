const ChartCard = ({ allReports }) => {
  const processedReports = allReports.filter((report) =>
    ["in_progress", "completed", "closed"].includes(report.status)
  ).length;

  const unprocessedReports = allReports.filter((report) =>
    ["pending", "verified"].includes(report.status)
  ).length;

  const totalValidReports = processedReports + unprocessedReports;

  const completionPercentage = totalValidReports > 0
    ? Math.round((processedReports / totalValidReports) * 100)
    : 0;

  return (
    <div className="card">
      <div className="row row-bordered g-0">
        <div className="col-md-8">
          <h5 className="card-header m-0 me-2 pb-3">
            Total Laporan ({new Date().getFullYear()})
          </h5>
          <div id="totalRevenueChart" className="px-2"></div>
        </div>
        <div className="col-md-4 d-flex flex-column justify-content-center align-items-center p-3">
          <div id="growthChart" ></div>
          <div className="text-center">
            <h3 className="fw-bold mb-1 text-success">{completionPercentage}%</h3>
            <p className="text-muted small mb-0">Laporan Sudah Di Proses</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ChartCard;
