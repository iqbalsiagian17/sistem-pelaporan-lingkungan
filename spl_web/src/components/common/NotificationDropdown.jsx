import React from "react";
import NotificationItem from "./NotificationItem";

const NotificationDropdown = ({ notifications }) => {
  const unreadCount = notifications.filter((n) => !n.is_read).length;

  return (
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
          {unreadCount > 0 && (
            <span className="badge rounded-pill bg-danger badge-dot badge-notifications border"></span>
          )}
        </span>
      </a>

      <ul className="dropdown-menu dropdown-menu-end p-0">
        <li className="dropdown-menu-header border-bottom">
          <div className="dropdown-header d-flex align-items-center py-3">
            <h6 className="mb-0 me-auto">Notifikasi</h6>
            <div className="d-flex align-items-center h6 mb-0">
              <span className="badge bg-label-primary me-2">{unreadCount} Baru</span>
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
            {notifications.slice(0, 5).map((notif, index) => (
              <NotificationItem key={notif.id} notif={notif} />
            ))}
            {notifications.length === 0 && (
              <li className="list-group-item text-center text-muted">
                Tidak ada notifikasi
              </li>
            )}
          </ul>
        </li>

        <li className="border-top">
          <div className="d-grid p-4">
            <a className="btn btn-primary btn-sm d-flex" href="/notifications">
              <small className="align-middle">Lihat semua notifikasi</small>
            </a>
          </div>
        </li>
      </ul>
    </li>
  );
};

export default NotificationDropdown;
