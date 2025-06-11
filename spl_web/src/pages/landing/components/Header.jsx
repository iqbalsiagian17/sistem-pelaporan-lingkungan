const Header = () => (
  <header className="masthead">
    <div className="container px-5">
      <div className="row gx-5 align-items-center">
        <div className="col-lg-6">
          <div className="mb-5 mb-lg-0 text-center text-lg-start">
            <h1 className="display-1 lh-1 mb-3">Untuk Balige yang Lebih Baik</h1>
            <p className="lead fw-normal text-muted mb-5">
              Balige Bersih adalah aplikasi pengaduan lingkungan yang memudahkan warga untuk melaporkan permasalahan sampah dan lingkungan secara cepat, praktis, dan transparan.
            </p>
            <div className="d-flex flex-column flex-lg-row align-items-center">
              <a className="me-lg-3 mb-4 mb-lg-0" href="#!">
                <img className="app-badge" src="/assets/img/landing/google-play-badge.svg" alt="Download dari Google Play" />
              </a>
              <a href="#!">
                <img className="app-badge" src="/assets/img/landing/app-store-badge.svg" alt="Download dari App Store" />
              </a>
            </div>
          </div>
        </div>
        <div className="col-lg-6">
          <div className="masthead-device-mockup">
            <svg className="circle" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <defs>
                <linearGradient id="circleGradient" gradientTransform="rotate(45)">
                  <stop className="gradient-start-color" offset="0%"></stop>
                  <stop className="gradient-end-color" offset="100%"></stop>
                </linearGradient>
              </defs>
              <circle cx="50" cy="50" r="50" />
            </svg>
              <svg className="shape-1 d-none d-sm-block" viewBox="0 0 240.83 240.83" xmlns="http://www.w3.org/2000/svg">
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
            <svg className="shape-2 d-none d-sm-block green-circle" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
              <circle cx="50" cy="50" r="50" />
            </svg>

            <div className="device-wrapper">
              <div className="device" data-device="iPhoneX" data-orientation="portrait" data-color="black">
                <div className="screen bg-black">
                  <video muted autoPlay loop style={{ maxWidth: "100%", height: "100%" }}>
                    <source src="/assets/img/landing/demo.mp4" type="video/mp4" />
                  </video>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>
);

export default Header;
