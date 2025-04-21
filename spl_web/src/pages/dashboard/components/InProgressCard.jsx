const InProgressCard = ({ inProgressReports }) => {
    return (
      <div className="card">
        <div className="card-body">
          <div className="card-title d-flex align-items-start justify-content-between">
            <div className="avatar flex-shrink-0">
              <div className="bg-warning rounded p-2">
                <i className="bx bx-time fs-3 text-white"></i>
              </div>
            </div>
          </div>
          <span className="fw-medium d-block mb-1">Laporan Belum Selesai</span>
          <h3 className="card-title text-nowrap mb-2">{inProgressReports}</h3>
          <small className="text-warning fw-medium">
            <i className="bx bx-time"></i> Dalam antrian
          </small>
        </div>
      </div>
    );
  };
  
  export default InProgressCard;
  