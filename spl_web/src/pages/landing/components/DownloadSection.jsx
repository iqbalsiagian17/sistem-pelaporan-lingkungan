const DownloadSection = () => {
  return (
    <section className="bg-gradient-primary-to-secondary" id="download">
      <div className="container px-5">
        <h2 className="text-center text-white font-alt mb-4">Unduh aplikasinya sekarang!</h2>
        <div className="d-flex flex-column flex-lg-row align-items-center justify-content-center">
          <a className="me-lg-3 mb-4 mb-lg-0" href="#!">
            <img
              className="app-badge"
              src="/assets/img/landing/google-play-badge.svg"
              alt="Google Play"
            />
          </a>
          <a href="#!">
            <img
              className="app-badge"
              src="/assets/img/landing/app-store-badge.svg"
              alt="App Store"
            />
          </a>
        </div>
      </div>
    </section>
  );
};

export default DownloadSection;
