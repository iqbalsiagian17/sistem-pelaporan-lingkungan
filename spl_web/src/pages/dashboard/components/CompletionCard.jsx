const CompletionCard = ({ completedReports, completionRate }) => (
    <div className="card">
      <div className="card-body">
        <div className="card-title d-flex align-items-start justify-content-between">
          <div className="avatar flex-shrink-0">
            <div className="bg-success rounded p-2">
              <i className="bx bx-check-circle fs-3 text-white"></i>
            </div>
          </div>
        </div>
        <span className="fw-medium d-block mb-1">Laporan Selesai</span>
        <h3 className="card-title mb-2">{completedReports}</h3>
        <small className="text-success fw-medium">
          <i className="bx bx-up-arrow-alt"></i> +{completionRate}% dari bulan lalu
        </small>
      </div>
    </div>
  );
  
  export default CompletionCard;
  