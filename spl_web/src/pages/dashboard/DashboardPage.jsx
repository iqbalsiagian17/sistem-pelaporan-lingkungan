import { useEffect, useState } from "react";
import { fetchOverview } from "../../services/analyticsService";
import { getAllReports } from "../../services/reportService";
import { getAllUsers } from "../../services/userService";
import { renderDashboardChart } from "../../utils/dashboardChart";
import { renderGrowthChart } from "../../utils/growthChart";
import { Link } from "react-router-dom";


export const DashboardPage = () => {
  const [overview, setOverview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [latestReports, setLatestReports] = useState([]);
  const [latestUsers, setLatestUsers] = useState([]);
  

  useEffect(() => {
    const loadAnalytics = async () => {
      try {
        const data = await fetchOverview();
        const allReports = await getAllReports();
        const allUsers = await getAllUsers();
  
        // Urutkan berdasarkan createdAt (paling baru di atas)
        const latestReports = allReports
          .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
          .slice(0, 5);
  
        const latestUsers = allUsers
          .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
          .slice(0, 5);
  
        setLatestReports(latestReports);
        setLatestUsers(latestUsers);
        setOverview(data);
      } catch (error) {
        console.error("Failed to load analytics data:", error);
      } finally {
        setLoading(false);
      }
    };
  
    loadAnalytics();
  }, []);
  

  useEffect(() => {
    if (overview) {
      renderDashboardChart(overview);

      const progress = Math.round((overview.completedReports / overview.totalReports) * 100) || 0;
      renderGrowthChart(progress);
  
    }
  }, [overview]);
  

  if (loading) return <div>Loading...</div>;
  if (!overview) return <div>Gagal memuat data analitik.</div>;

  const {
    totalReports = 0,
    completedReports = 0,
    inProgressReports = 0,
    rejectedReports = 0,
    newReports = 0,
    urgentReports = 0,
    completionRate = 0,
    completionThisMonth = 0,
  } = overview;

      return (
        <>
            <div className="row">
                <div className="col-lg-8 mb-4 order-0">
                    <div className="card">
                        <div className="d-flex align-items-end row">
                            <div className="col-sm-7">
                                <div className="card-body">
                                    <h5 className="card-title text-primary">
                                        Selamat Datang di Sistem Pelaporan Masyarakat Balige Bersih!
                                    </h5>
                                    <p className="mb-4">
                                        Total <span className="fw-medium">{totalReports}</span> laporan telah di terima. Pantau perkembangan laporan masyarakat secara real-time
                                    </p>

                                    <Link aria-label="view badges"
                                        to="/reports"
                                        className="btn btn-sm btn-outline-primary"
                                    >
                                        Lihat Semua Laporan
                                    </Link>
                                </div>
                            </div>
                            <div className="col-sm-5 text-center text-sm-left">
                                <div className="card-body pb-0 px-0 px-md-4">
                                    <img aria-label='dsahboard icon image'
                                        src="/assets/img/illustrations/man-with-laptop-light.png"
                                        height="140"
                                        alt="View Badge User"
                                        data-app-dark-img="illustrations/man-with-laptop-dark.png"
                                        data-app-light-img="illustrations/man-with-laptop-light.png"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col-lg-4 col-md-4 order-1">
                    <div className="row">
                        <div className="col-lg-6 col-md-12 col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img aria-label='dsahboard icon image'
                                                src="/assets/img/icons/unicons/chart-success.png"
                                                alt="chart success"
                                                className="rounded"
                                            />
                                        </div>
                                    </div>
                                    <span className="fw-medium d-block mb-1">Laporan Selesai</span>
                                    <h3 className="card-title mb-2">{completedReports}</h3>
                                    <small className="text-success fw-medium">
                                        <i className="bx bx-up-arrow-alt"></i> +{completionRate}% dari bulan lalu
                                    </small>
                                </div>
                            </div>
                        </div>
                        <div className="col-lg-6 col-md-12 col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img aria-label='dsahboard icon image'
                                                src="/assets/img/icons/unicons/wallet-info.png"
                                                alt="Credit Card"
                                                className="rounded"
                                            />
                                        </div>
                                    </div>
                                    <span>Laporan Belum Selesai</span>
                                    <h3 className="card-title text-nowrap mb-1">{inProgressReports}</h3>
                                    <small className="text-success fw-medium">
                                        <i className="bx bx-up-arrow-alt"></i> Dalam antrian
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-lg-8 order-2 order-md-3 order-lg-2 mb-4">
                    <div className="card">
                        <div className="row row-bordered g-0">
                            <div className="col-md-8">
                                <h5 className="card-header m-0 me-2 pb-3">Total Laporan</h5>
                                <div id="totalRevenueChart" className="px-2"></div>
                            </div>
                            <div className="col-md-4">
                                <div className="card-body">
                                </div>
                                <div id="growthChart"></div>
                                <div className="text-center fw-medium pt-3 mb-2">
                                {Math.round((completedReports / totalReports) * 100) || 0} %Laporan Sudah Diproses
                                </div>

                                <div className="d-flex px-xxl-4 px-lg-2 p-4 gap-xxl-3 gap-lg-1 gap-3 justify-content-between">
                                    <div className="d-flex">
                                        <div className="me-2">
                                            <span className="badge bg-label-primary p-2">
                                                <i className="bx bx-dollar text-primary"></i>
                                            </span>
                                        </div>
                                        <div className="d-flex flex-column">
                                            <small>Laporan Belum Selesai</small>
                                            <h6 className="mb-0">{inProgressReports}</h6>
                                        </div>
                                    </div>
                                    <div className="d-flex">
                                        <div className="me-2">
                                            <span className="badge bg-label-info p-2">
                                                <i className="bx bx-wallet text-info"></i>
                                            </span>
                                        </div>
                                        <div className="d-flex flex-column">
                                            <small>Laporan Selesai</small>
                                            <h6 className="mb-0">{completedReports}</h6>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-md-8 col-lg-4 order-3 order-md-2">
                    <div className="row">
                        <div className="col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img aria-label='dsahboard icon image'
                                                src="/assets/img/icons/unicons/paypal.png"
                                                alt="Credit Card"
                                                className="rounded"
                                            />
                                        </div>
                                    </div>
                                    <span className="d-block mb-1">Laporan Tidak Valid</span>
                                    <h3 className="card-title text-nowrap mb-2">{rejectedReports}</h3>
                                    <small className="text-danger fw-medium">
                                        <i className="bx bx-down-arrow-alt"></i>Butuh Tindakan Segera
                                    </small>
                                </div>
                            </div>
                        </div>
                        <div className="col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img aria-label='dsahboard icon image'
                                                src="/assets/img/icons/unicons/cc-primary.png"
                                                alt="Credit Card"
                                                className="rounded"
                                            />
                                        </div>
                                    </div>
                                    <span className="fw-medium d-block mb-1">Laporan Baru</span>
                                    <h3 className="card-title mb-2">{newReports}</h3>
                                    <small className="text-success fw-medium">
                                        <i className="bx bx-up-arrow-alt"></i> Laporan Masuk Hari Ini
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div className="col-12 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="d-flex justify-content-between flex-sm-row flex-column gap-3">
                                        <div className="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                                            <div className="card-title">
                                                <h5 className="text-nowrap mb-2">Tingkat Penyelesaian</h5>
                                                <span className="badge bg-label-warning rounded-pill">
                                                    Bulan ini
                                                </span>
                                            </div>
                                            <div className="mt-sm-auto">
                                                <small className="text-success text-nowrap fw-medium">
                                                    <i className="bx bx-chevron-up"></i> {completionRate}%
                                                </small>
                                                <h3 className="mb-0">{completionThisMonth} Selesai</h3>
                                            </div>
                                        </div>
                                        <div id="profileReportChart"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div className="row mt-4">
                <div className="col-md-6 col-12 mb-4">
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
                        <tbody className="table-border-bottom-0">
                            {latestReports.length === 0 ? (
                            <tr>
                                <td colSpan="4" className="text-center text-muted">Belum ada laporan baru.</td>
                            </tr>
                            ) : (
                            latestReports.map((report, index) => (
                                <tr key={index}>
                                <td>{report.report_number}</td>
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
                </div>

                {/* Pengguna Terbaru */}
                <div className="col-md-6 col-12 mb-4">
                    <div className="card">
                    <div className="card-header pb-2">
                        <h5 className="mb-1">Pengguna Terbaru</h5>
                        <small className="text-muted">5 akun pengguna terbaru</small>
                    </div>
                    <div className="table-responsive text-nowrap">
                        <table className="table table-hover">
                        <thead className="table-light">
                            <tr>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Jenis Akun</th>
                            <th>Terdaftar</th>
                            </tr>
                        </thead>
                        <tbody className="table-border-bottom-0">
                            {latestUsers.length === 0 ? (
                            <tr>
                                <td colSpan="4" className="text-center text-muted">Belum ada pengguna baru.</td>
                            </tr>
                            ) : (
                            latestUsers.map((user, index) => (
                                <tr key={index}>
                                <td className="fw-semibold">{user.username}</td>
                                <td>{user.email}</td>
                                <td>
                                    <span className="badge bg-label-primary">{user.auth_provider || "-"}</span>
                                </td>
                                <td>
                                    {user.createdAt && !isNaN(new Date(user.createdAt))
                                    ? new Date(user.createdAt).toLocaleString("id-ID")
                                    : "-"}
                                </td>
                                </tr>
                            ))
                            )}
                        </tbody>
                        </table>
                    </div>
                    </div>
                </div>
            </div>
        </>
    );
};