import getGreetingMessage from '../utils/greetingHandler';
import { useNavigate } from "react-router-dom";
import { fetchAdminNotifications } from "../services/notificationService";
import React, { useState, useEffect } from "react";
import NotificationItem from "../components/common/NotificationItem";





const Navbar = () => {

  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    const getNotifications = async () => {
      try {
        const data = await fetchAdminNotifications();
        setNotifications(data.slice(0, 5)); // tampilkan 5 terbaru
      } catch (err) {
        console.error("Gagal mengambil notifikasi:", err);
      }
    };
  
    getNotifications();
  }, []);
  

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
      <ul className="navbar-nav flex-row align-items-center ms-auto" >
        
          
          {/* Notification Bell Icon - Mobile Friendly */}
          <li className="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-2">
  <a
    className="nav-link dropdown-toggle hide-arrow"
    href="#"
    data-bs-toggle="dropdown"
    data-bs-auto-close="outside"
    aria-expanded="false"
  >
    <span className="position-relative">
      <i className="icon-base bx bx-bell icon-md"></i>
      {notifications.filter(n => !n.is_read).length > 0 && (
        <span className="badge rounded-pill bg-danger badge-dot badge-notifications border"></span>
      )}
    </span>
  </a>

  <ul className="dropdown-menu dropdown-menu-end p-0"   style={{ minWidth: "500px", maxWidth: "650px" }}
  >
    <li className="dropdown-menu-header border-bottom">
      <div className="dropdown-header d-flex align-items-center py-3">
        <h6 className="mb-0 me-auto">Notifikasi</h6>
        <div className="d-flex align-items-center h6 mb-0">
          <span className="badge bg-label-primary me-2">
            {notifications.filter(n => !n.is_read).length} Baru
          </span>
          <a
            href="#"
            className="dropdown-notifications-all p-2"
            title="Tandai semua telah dibaca"
          >
            <i className="icon-base bx bx-envelope-open text-heading"></i>
          </a>
        </div>
      </div>
    </li>

    <li className="dropdown-notifications-list scrollable-container">
      <ul className="list-group list-group-flush">
        {notifications.length > 0 ? (
          notifications.slice(0, 5).map((notif, index) => (
            <li
              className={`list-group-item list-group-item-action dropdown-notifications-item ${
                notif.is_read ? "marked-as-read" : ""
              }`}
              key={index}
            >
              <NotificationItem notif={notif} />
            </li>
          ))
        ) : (
          <li className="list-group-item text-center text-muted">
            Tidak ada notifikasi
          </li>
        )}
      </ul>
    </li>

    <li className="border-top">
      <div className="d-grid p-3">
        <a className="btn btn-sm btn-primary d-block" href="/notifications">
          Lihat semua notifikasi
        </a>
      </div>
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
