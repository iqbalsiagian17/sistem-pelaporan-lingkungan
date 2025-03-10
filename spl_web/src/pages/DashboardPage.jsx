import { useEffect } from "react";

export const DashboardPage = () => {
    useEffect(() => {
        dashboardAnalitics();
    }, [])
    return (
        <>
            <div className="row">
                <div className="col-lg-8 mb-4 order-0">
                    <div className="card">
                        <div className="d-flex align-items-end row">
                            <div className="col-sm-7">
                                <div className="card-body">
                                    <h5 className="card-title text-primary">
                                    Selamat Datang di Sistem Pelaporan Masyarakat! 📢
                                    </h5>
                                    <p className="mb-4">
                                    Total <span className="fw-medium">1.245</span> laporan telah
                                        diterima bulan ini. Pantau perkembangan laporan masyarakat secara real-time.
                                    </p>

                                    <a aria-label="view badges"
                                        href="#"
                                        className="btn btn-sm btn-outline-primary"
                                    >
                                        Lihat Semua Laporan
                                    </a>
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
                                        <div className="dropdown">
                                            <button aria-label='Click me'
                                                className="btn p-0"
                                                type="button"
                                                id="cardOpt3"
                                                data-bs-toggle="dropdown"
                                                aria-haspopup="true"
                                                aria-expanded="false"
                                            >
                                                <i className="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div
                                                className="dropdown-menu dropdown-menu-end"
                                                aria-labelledby="cardOpt3"
                                            >
                                                <a aria-label="view more" className="dropdown-item" href="#">
                                                    View More
                                                </a>
                                                <a aria-label="delete" className="dropdown-item" href="#">
                                                    Delete
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <span className="fw-medium d-block mb-1">Laporan Selesai</span>
                                    <h3 className="card-title mb-2">850</h3>
                                    <small className="text-success fw-medium">
                                    <i className="bx bx-up-arrow-alt"></i> +30% dari bulan lalu
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
                                        <div className="dropdown">
                                            <button aria-label='Click me'
                                                className="btn p-0"
                                                type="button"
                                                id="cardOpt6"
                                                data-bs-toggle="dropdown"
                                                aria-haspopup="true"
                                                aria-expanded="false"
                                            >
                                                <i className="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div
                                                className="dropdown-menu dropdown-menu-end"
                                                aria-labelledby="cardOpt6"
                                            >
                                                <a aria-label="view more" className="dropdown-item" href="#">
                                                    View More
                                                </a>
                                                <a aria-label="delete" className="dropdown-item" href="#">
                                                    View More
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <span>Laporan Diproses</span>
                                        <h3 className="card-title text-nowrap mb-1">250</h3>
                                    <small className="text-success fw-medium">
                                        <i className="bx bx-time"></i> Dalam antrian
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-lg-8 order-2 order-md-3 order-lg-2 mb-4">
                    <div className="card h-100">
                        <div className="row row-bordered g-0">
                            {/* Grafik Laporan */}
                            <div className="col-md-8 d-flex flex-column">
                                <h5 className="card-header m-0 me-2 pb-3">Statistik Laporan Masyarakat</h5>
                                <div id="totalReportChart" className="px-2 flex-grow-1" style={{ minHeight: "350px" }}></div>
                            </div>

                            {/* Statistik Laporan */}
                            <div className="col-md-4 d-flex flex-column justify-content-between">
                                <div className="card-body">
                                    <div className="text-center">
                                        <div className="dropdown">
                                            <button
                                                aria-label="Pilih Tahun"
                                                className="btn btn-sm btn-outline-primary dropdown-toggle"
                                                type="button"
                                                id="reportYearDropdown"
                                                data-bs-toggle="dropdown"
                                                aria-haspopup="true"
                                                aria-expanded="false"
                                            >
                                                2024
                                            </button>
                                            <div className="dropdown-menu dropdown-menu-end" aria-labelledby="reportYearDropdown">
                                                <a className="dropdown-item" href="#">2023</a>
                                                <a className="dropdown-item" href="#">2022</a>
                                                <a className="dropdown-item" href="#">2021</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div id="growthChart" style={{ minHeight: "200px" }}></div>

                                <div className="text-center fw-medium pt-3 mb-2">
                                    78% Laporan Sudah Diproses
                                </div>

                                <div className="d-flex px-xxl-4 px-lg-2 p-4 gap-xxl-3 gap-lg-1 gap-3 justify-content-between">
                                    {/* Jumlah Laporan Baru */}
                                    <div className="d-flex">
                                        <div className="me-2">
                                            <span className="badge bg-label-primary p-2">
                                                <i className="bx bx-file text-primary"></i>
                                            </span>
                                        </div>
                                        <div className="d-flex flex-column">
                                            <span className="d-block mb-1">Laporan Baru</span>
                                            <h3 className="card-title text-nowrap mb-2">312</h3>
                                        </div>
                                    </div>

                                    {/* Jumlah Laporan Selesai */}
                                    <div className="d-flex">
                                        <div className="me-2">
                                            <span className="badge bg-label-success p-2">
                                                <i className="bx bx-check-circle text-success"></i>
                                            </span>
                                        </div>
                                        <div className="d-flex flex-column">
                                            <span className="d-block mb-1">Laporan Selesai</span>
                                            <h3 className="card-title text-nowrap mb-2">245</h3>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="col-12 col-md-8 col-lg-4 order-3 order-md-2">
                    <div className="row">
                        {/* Laporan Mendesak */}
                        <div className="col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img 
                                                aria-label='Urgent Reports Icon' 
                                                src="/assets/img/icons/unicons/wallet-info.png"
                                                alt="Urgent Reports"
                                                className="rounded"
                                            />
                                        </div>
                                        <div className="dropdown">
                                            <button 
                                                aria-label='Options'
                                                className="btn p-0"
                                                type="button"
                                                id="cardOptUrgent"
                                                data-bs-toggle="dropdown"
                                                aria-haspopup="true"
                                                aria-expanded="false"
                                            >
                                                <i className="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div className="dropdown-menu dropdown-menu-end" aria-labelledby="cardOptUrgent">
                                                <a className="dropdown-item" href="#">Lihat Detail</a>
                                                <a className="dropdown-item" href="#">Tindak Lanjut</a>
                                            </div>
                                        </div>
                                    </div>
                                    <span className="d-block mb-1">Laporan Mendesak</span>
                                    <h3 className="card-title text-nowrap mb-2">57</h3>
                                    <small className="text-danger fw-medium">
                                        <i className="bx bx-error-circle"></i> Butuh Tindakan Segera
                                    </small>
                                </div>
                            </div>
                        </div>

                        {/* Laporan Baru */}
                        <div className="col-6 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="card-title d-flex align-items-start justify-content-between">
                                        <div className="avatar flex-shrink-0">
                                            <img 
                                                aria-label='New Reports Icon' 
                                                src="/assets/img/icons/unicons/cc-primary.png"
                                                alt="New Reports"
                                                className="rounded"
                                            />
                                        </div>
                                        <div className="dropdown">
                                            <button 
                                                aria-label='Options'
                                                className="btn p-0"
                                                type="button"
                                                id="cardOptNew"
                                                data-bs-toggle="dropdown"
                                                aria-haspopup="true"
                                                aria-expanded="false"
                                            >
                                                <i className="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div className="dropdown-menu dropdown-menu-end" aria-labelledby="cardOptNew">
                                                <a className="dropdown-item" href="#">Lihat Detail</a>
                                                <a className="dropdown-item" href="#">Proses Laporan</a>
                                            </div>
                                        </div>
                                    </div>
                                    <span className="fw-medium d-block mb-1">Laporan Baru</span>
                                    <h3 className="card-title mb-2">312</h3>
                                    <small className="text-primary fw-medium">
                                        <i className="bx bx-file"></i> Laporan Masuk Hari Ini
                                    </small>
                                </div>
                            </div>
                        </div>

                        {/* Statistik Penyelesaian */}
                        <div className="col-12 mb-4">
                            <div className="card">
                                <div className="card-body">
                                    <div className="d-flex justify-content-between flex-sm-row flex-column gap-3">
                                        <div className="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                                            <div className="card-title">
                                                <h5 className="text-nowrap mb-2">Tingkat Penyelesaian</h5>
                                                <span className="badge bg-label-success rounded-pill">Bulan Ini</span>
                                            </div>
                                            <div className="mt-sm-auto">
                                                <small className="text-success text-nowrap fw-medium">
                                                    <i className="bx bx-chevron-up"></i> 78.5%
                                                </small>
                                                <h3 className="mb-0">245 Laporan Selesai</h3>
                                            </div>
                                        </div>
                                        <div id="completionChart"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </>
    );
};





