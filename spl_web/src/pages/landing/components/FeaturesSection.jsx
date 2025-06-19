const FeaturesSection = ({ parameter }) => {
  const videoSrc = parameter?.landing_video
    ? `http://localhost:3000${parameter.landing_video}`
    : null;

  return (
    <section id="features">
      <div className="container px-5">
        <div className="row gx-5 align-items-center">
          {/* Left: Fitur-fitur */}
          <div className="col-lg-8 order-lg-1 mb-5 mb-lg-0">
            <div className="container-fluid px-5">
              <div className="row gx-5">
                <div className="col-md-6 mb-5">
                  <div className="text-center">
                    <i className="bi bi-megaphone icon-feature text-gradient d-block mb-3"></i>
                    <h3 className="font-alt">Laporan Cepat</h3>
                    <p className="text-muted mb-0">
                      Laporkan masalah lingkungan di Balige secara real-time dengan mudah.
                    </p>
                  </div>
                </div>
                <div className="col-md-6 mb-5">
                  <div className="text-center">
                    <i className="bi bi-bell icon-feature text-gradient d-block mb-3"></i>
                    <h3 className="font-alt">Notifikasi Langsung</h3>
                    <p className="text-muted mb-0">
                      Dapatkan update dan status penanganan laporan Anda secara langsung.
                    </p>
                  </div>
                </div>
              </div>

              <div className="row">
                <div className="col-md-6 mb-5 mb-md-0">
                  <div className="text-center">
                    <i className="bi bi-map icon-feature text-gradient d-block mb-3"></i>
                    <h3 className="font-alt">Lokasi Akurat</h3>
                    <p className="text-muted mb-0">
                      Gunakan fitur peta untuk menunjukkan lokasi tepat dari masalah lingkungan.
                    </p>
                  </div>
                </div>
                <div className="col-md-6">
                  <div className="text-center">
                    <i className="bi bi-chat-dots icon-feature text-gradient d-block mb-3"></i>
                    <h3 className="font-alt">Interaksi & Komentar</h3>
                    <p className="text-muted mb-0">
                      Tanggapi dan diskusikan laporan dari warga lain secara terbuka.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right: Video Mockup */}
          <div className="col-lg-4 order-lg-0">
            <div className="features-device-mockup">
              {/* Shapes */}
              <svg className="circle" viewBox="0 0 100 100">
                <circle cx="50" cy="50" r="50" />
              </svg>
              <svg className="shape-1 d-none d-sm-block" viewBox="0 0 240.83 240.83">
                <rect
                  x="-32.54"
                  y="78.39"
                  width="305.92"
                  height="84.05"
                  rx="42.03"
                  transform="translate(120.42 -49.88) rotate(45)"
                  fill="#66BB6A"
                />
                <rect
                  x="-32.54"
                  y="78.39"
                  width="305.92"
                  height="84.05"
                  rx="42.03"
                  transform="translate(-49.88 120.42) rotate(-45)"
                  fill="#66BB6A"
                />
              </svg>
              <svg className="shape-2 d-none d-sm-block green-circle" viewBox="0 0 100 100">
                <circle cx="50" cy="50" r="50" />
              </svg>

              {/* Device Preview */}
              <div className="device-wrapper">
                <div className="device" data-device="iPhoneX" data-orientation="portrait" data-color="black">
                  <div className="screen bg-black">
                    {videoSrc ? (
                      <video muted autoPlay loop playsInline style={{ width: "100%", height: "100%" }}>
                        <source src={videoSrc} type="video/mp4" />
                        Your browser does not support the video tag.
                      </video>
                    ) : (
                      <div className="text-white text-center mt-4">Memuat video...</div>
                    )}
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
