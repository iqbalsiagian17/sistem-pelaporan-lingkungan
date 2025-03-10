import getGreetingMessage from '../utils/greetingHandler';
import { useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";



const Navbar = () => {

  const navigate = useNavigate();
  const [user, setUser] = useState(null);


    // Ambil data user dari localStorage saat komponen dimuat
    useEffect(() => {
      const userData = localStorage.getItem("user");
      if (userData) {
        setUser(JSON.parse(userData));
      }
    }, []);


    const handleLogout = () => {
      localStorage.removeItem("accessToken"); // Hapus token
      localStorage.removeItem("user"); // Hapus user data
      navigate("/auth/login"); // Redirect ke login
    };


  return (
    <nav
      className="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
      id="layout-navbar">
      <div className="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
        <a aria-label='toggle for sidebar' className="nav-item nav-link px-0 me-xl-4" href="#">
          <i className="bx bx-menu bx-sm"></i>
        </a>
      </div>

      <div className="navbar-nav-right d-flex align-items-center w-100" id="navbar-collapse">
        {user ? getGreetingMessage(user.username) : getGreetingMessage('User')}
      <ul className="navbar-nav flex-row align-items-center ms-auto">
          
          {/* Notification Bell Icon - Mobile Friendly */}
          <li className="nav-item dropdown position-relative me-3">
            <a
              aria-label="Notifications"
              className="nav-link"
              href="#"
              data-bs-toggle="dropdown"
              role="button"
              aria-expanded="false"
              style={{ position: "relative", display: "flex", alignItems: "center" }}
            >
              <i className="bx bx-bell bx-sm"></i>
              <span
                className="badge rounded-pill bg-danger position-absolute"
                style={{
                  fontSize: "0.75rem",
                  padding: "4px 6px",
                  top: "5px",
                  right: "-2px",
                }}
              >
                3
              </span>
            </a>

            {/* Dropdown Menu - Adjusted for Mobile */}
            <ul
                className="dropdown-menu dropdown-menu-end shadow-lg border-0 p-2"
                data-bs-auto-close="outside"
                style={{
                  maxWidth: "350px",
                  minWidth: "260px",
                  borderRadius: "10px",
                  overflow: "hidden",
                  position: "absolute",
                  right: "0",
                  left: "auto",
                  transform: "translateX(0%)",
                  backgroundColor: "#ffffff",
                }}
              >
                {/* Header */}
                <li className="dropdown-header bg-primary text-white fw-bold py-2 px-3 d-flex align-items-center">
                  <i className="bx bx-bell text-white fs-5 me-2"></i> Notifikasi
                </li>

                <li><hr className="dropdown-divider m-0" /></li>

                {/* Notification Items */}
                <li className="px-3 py-2">
                  <a className="dropdown-item d-flex align-items-center p-2 rounded" href="#" style={{ transition: "0.2s ease-in-out" }}>
                    <i className="bx bx-envelope text-primary fs-4 me-3"></i>
                    <div>
                      <span className="fw-semibold">Pesan Baru</span>
                      <small className="d-block text-muted">Baru saja</small>
                    </div>
                  </a>
                </li>

                <li className="px-3 py-2">
                  <a className="dropdown-item d-flex align-items-center p-2 rounded" href="#" style={{ transition: "0.2s ease-in-out" }}>
                    <i className="bx bx-user-plus text-success fs-4 me-3"></i>
                    <div>
                      <span className="fw-semibold">Pengguna Baru</span>
                      <small className="d-block text-muted">5 menit lalu</small>
                    </div>
                  </a>
                </li>

                <li className="px-3 py-2">
                  <a className="dropdown-item d-flex align-items-center p-2 rounded" href="#" style={{ transition: "0.2s ease-in-out" }}>
                    <i className="bx bx-error-circle text-danger fs-4 me-3"></i>
                    <div>
                      <span className="fw-semibold">Peringatan Sistem</span>
                      <small className="d-block text-muted">10 menit lalu</small>
                    </div>
                  </a>
                </li>

                <li><hr className="dropdown-divider m-0" /></li>

                {/* View All Notifications */}
                <li className="text-center py-2">
                  <a className="dropdown-item text-primary fw-bold p-2 rounded" href="#" style={{ transition: "0.2s ease-in-out" }}>
                    Lihat semua notifikasi
                  </a>
                </li>
              </ul>

          </li>

          {/* User Avatar Dropdown */}
          <li className="nav-item navbar-dropdown dropdown-user dropdown">
            <a aria-label='dropdown profile avatar' className="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown">
              <div className="avatar avatar-online">
                <img src="../assets/img/avatars/1.png" className="w-px-40 h-auto rounded-circle" alt="avatar-image" aria-label='Avatar Image'/>
              </div>
            </a>
            <ul className="dropdown-menu dropdown-menu-end">
              <li>
                <a aria-label='go to profile' className="dropdown-item" href="#">
                  <div className="d-flex">
                    <div className="flex-shrink-0 me-3">
                      <div className="avatar avatar-online">
                        <img src="../assets/img/avatars/1.png" className="w-px-40 h-auto rounded-circle" alt='avatar-image' aria-label='Avatar Image' />
                      </div>
                    </div>
                    <div className="flex-grow-1">
                      <span className="fw-medium d-block">{user ? user.username : "Guest"}</span>
                      <small className="text-muted">{user ? user.email : "No Email"}</small>
                    </div>
                  </div>
                </a>
              </li>
              <li><div className="dropdown-divider"></div></li>
              <li>
                <button aria-label='click to log out' className="dropdown-item" onClick={handleLogout}>
                  <i className="bx bx-log-out me-2"></i>
                  <span className="align-middle">Log Out</span>
                </button>
                <a aria-label='click to log out' className="dropdown-item" href="#">
                  <i className="bx bx-power-off me-2"></i>
                  <span className="align-middle">Log Out</span>
                </a>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  );
}

export default Navbar;
