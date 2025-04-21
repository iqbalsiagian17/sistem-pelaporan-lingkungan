import { Link } from "react-router-dom";

const WelcomeCard = ({ totalReports }) => (
  <div className="card">
    <div className="d-flex align-items-end row">
      <div className="col-sm-7">
        <div className="card-body">
          <h5 className="card-title text-primary">Selamat Datang di Sistem Pelaporan Masyarakat Balige Bersih!</h5>
          <p className="mb-4">
            Total <span className="fw-medium">{totalReports}</span> laporan telah diterima. Pantau perkembangan laporan masyarakat secara real-time.
          </p>
          <Link to="/reports" className="btn btn-sm btn-outline-primary">
            Lihat Semua Laporan
          </Link>
        </div>
      </div>
      <div className="col-sm-5 text-center text-sm-left">
        <div className="card-body pb-0 px-0 px-md-4">
          <img
            src="/assets/img/illustrations/man-with-laptop-light.png"
            height="140"
            alt="Illustration"
          />
        </div>
      </div>
    </div>
  </div>
);

export default WelcomeCard;
