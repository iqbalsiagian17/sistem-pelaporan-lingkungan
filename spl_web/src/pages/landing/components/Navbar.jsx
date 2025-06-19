import { useEffect } from "react";

const Navbar = () => {
  useEffect(() => {
    // Tambahkan style tag untuk hover efek
    const style = document.createElement("style");
    style.innerHTML = `
      .navbar-brand:hover {
        color: #66BB6A !important;
        transition: color 0.3s ease;
      }
    `;
    document.head.appendChild(style);

    return () => {
      document.head.removeChild(style);
    };
  }, []);

  return (
    <nav className="navbar navbar-expand-lg navbar-light fixed-top shadow-sm" id="mainNav">
      <div className="container px-5">
        <a
          className="navbar-brand fw-bold"
          href="#page-top"
          style={{ color: "#000", textDecoration: "none" }} // warna default
        >
          BaligeBersih
        </a>
        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarResponsive"
          aria-controls="navbarResponsive"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          Menu <i className="bi bi-list"></i>
        </button>
        <div className="collapse navbar-collapse" id="navbarResponsive">
          <ul className="navbar-nav ms-auto me-4 my-3 my-lg-0">
            <li className="nav-item">
              <a className="nav-link me-lg-3" href="#features">Fitur</a>
            </li>
          </ul>
          <button className="btn btn-primary rounded-pill px-3 mb-2 mb-lg-0" data-bs-toggle="modal" data-bs-target="#feedbackModal">
            <span className="d-flex align-items-center">
              <i className="bi bi-download me-2"></i>
              <span className="small">Unduh</span>
            </span>
          </button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
