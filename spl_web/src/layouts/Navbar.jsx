import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import getGreetingMessage from "../utils/greetingHandler";
import { fetchAdminNotifications } from "../services/notificationService";
import NotificationItem from "../components/common/NotificationItem";
import NotificationModal from "../components/common/NotificationModal";

const Navbar = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [notifications, setNotifications] = useState([]);
  const [showModal, setShowModal] = useState(false);

  const handleOpenModal = () => setShowModal(true);
  const handleCloseModal = () => setShowModal(false);

  const getNotifications = async () => {
    try {
      const data = await fetchAdminNotifications();
      setNotifications(data);
    } catch (err) {
      console.error("Gagal mengambil notifikasi:", err);
    }
  };

  useEffect(() => {
    getNotifications();
  }, []);

  useEffect(() => {
    const userData = localStorage.getItem("user");
    if (userData) {
      setUser(JSON.parse(userData));
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("user");
    navigate("/auth/login");
  };

  const handleMarkAllAsRead = async () => {
    try {
      const token = localStorage.getItem("accessToken");
      console.log("🔑 Token:", token);
  
      const res = await fetch("http://localhost:3000/api/notifications/read-all", {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      });
  
      const data = await res.json();
      console.log("✅ Response:", data);
  
      if (res.ok) {
        getNotifications(); // Refresh setelah ditandai semua
      } else {
        alert(data.message || "Gagal menandai semua notifikasi.");
      }
    } catch (err) {
      console.error("❌ Gagal menandai semua dibaca:", err);
      alert("Terjadi kesalahan saat menandai semua notifikasi.");
    }
  };
  
  const unreadCount = notifications.filter((n) => !n.is_read).length;

  return (
    <>
      <nav className="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme" id="layout-navbar">
        <div className="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
          <a className="nav-item nav-link px-0 me-xl-4" href="#">
            <i className="bx bx-menu bx-sm"></i>
          </a>
        </div>

        <div className="navbar-nav-right d-flex align-items-center w-100" id="navbar-collapse">
          {user ? getGreetingMessage(user.username) : getGreetingMessage("User")}

          <ul className="navbar-nav flex-row align-items-center ms-auto">
            {/* NOTIFICATIONS */}
            <li className="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-2">
              <a className="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown" data-bs-auto-close="outside">
                <span className="position-relative">
                  <i className="icon-base bx bx-bell icon-md"></i>
                  {unreadCount > 0 && (
                    <span
                      className="badge bg-danger rounded-circle badge-notifications"
                      style={{
                        position: "absolute",
                        top: "-6px",
                        right: "-6px",
                        fontSize: "10px",
                        padding: "3px 6px",
                        minWidth: "20px",
                        height: "20px",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                      }}
                    >
                      {unreadCount}
                    </span>
                  )}
                </span>
              </a>

              <ul className="dropdown-menu dropdown-menu-end p-0" style={{ minWidth: "500px", maxWidth: "650px" }}>
                <li className="dropdown-menu-header border-bottom">
                  <div className="dropdown-header d-flex align-items-center py-3">
                    <h6 className="mb-0 me-auto">Notifikasi</h6>
                    <div className="d-flex align-items-center h6 mb-0">
                      <span className="badge bg-label-primary me-2">{unreadCount} Baru</span>

                      {unreadCount > 1 && (
                        <button
                          className="btn btn-sm btn-outline-primary d-flex align-items-center gap-2"
                          onClick={handleMarkAllAsRead}
                        >
                          <i className="bx bx-envelope-open"></i>
                          <span className="d-none d-md-inline">Tandai semua dibaca</span>
                        </button>
                      )}

                      {unreadCount === 0 && (
                        <i className="icon-base bx bx-envelope-open text-heading"></i>
                      )}
                    </div>
                  </div>
                </li>

                <li className="dropdown-notifications-list scrollable-container">
                  <ul className="list-group list-group-flush">
                    {notifications.length > 0 ? (
                      notifications.slice(0, 5).map((notif, index) => (
                        <li key={index} className={`list-group-item list-group-item-action dropdown-notifications-item ${notif.is_read ? "marked-as-read" : ""}`}>
                          <NotificationItem notif={notif} />
                        </li>
                      ))
                    ) : (
                      <li className="list-group-item text-center text-muted">Tidak ada notifikasi</li>
                    )}
                  </ul>
                </li>

                <li className="border-top">
                  <div className="d-grid p-3">
                    <button className="btn btn-sm btn-primary d-block" onClick={handleOpenModal}>
                      Lihat semua notifikasi
                    </button>
                  </div>
                </li>
              </ul>
            </li>

            {/* USER DROPDOWN */}
            <li className="nav-item navbar-dropdown dropdown-user dropdown">
              <a className="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown">
                <div className="avatar avatar-online">
                  <img src="../assets/img/avatars/admin.png" className="w-px-40 h-auto rounded-circle" alt="avatar" />
                </div>
              </a>
              <ul className="dropdown-menu dropdown-menu-end">
                <li>
                  <a className="dropdown-item" href="#">
                    <div className="d-flex">
                      <div className="flex-shrink-0 me-3">
                        <div className="avatar avatar-online">
                          <img src="../assets/img/avatars/admin.png" className="w-px-40 h-auto rounded-circle" alt="avatar" />
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
                  <button className="dropdown-item" onClick={handleLogout}>
                    <i className="bx bx-log-out me-2"></i>
                    <span className="align-middle">Log Out</span>
                  </button>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </nav>

      {/* Modal */}
      <NotificationModal
  show={showModal}
  onClose={handleCloseModal}
  notifications={notifications}
  onMarkAllRead={handleMarkAllAsRead}
/>
    </>
  );
};

export default Navbar;
