const Footer = () => {
    return (
        <footer className="content-footer footer bg-footer-theme">
            <div className="container-xxl d-flex flex-wrap justify-content-center py-2 flex-md-row flex-column">
              <div className="mb-2 mb-md-0">
                ©
                  {(new Date().getFullYear())},  <a aria-label="go to developer github Dwiwijaya" href="https://github.com/11Dwiwijaya/react-sneat-bootstrap-admin-template" target="_blank" rel='noreferrer' className="footer-link fw-medium">Dinas Lingkungan Hidup Toba</a>
              </div>
            </div>
          </footer>
      );
}
export default Footer;