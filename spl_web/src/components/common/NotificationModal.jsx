import React from "react";
import NotificationItem from "./NotificationItem";

const NotificationModal = ({ show, onClose, notifications, onMarkAllRead }) => {
  if (!show) return null;

  const unreadCount = notifications.filter((n) => !n.is_read).length;

  return (
    <div className="modal fade show d-block" style={{ backgroundColor: "rgba(0,0,0,0.5)" }}>
      <div className="modal-dialog modal-lg modal-dialog-scrollable">
        <div className="modal-content">
          <div className="modal-header d-flex justify-content-between align-items-center">
            <h5 className="modal-title mb-0">Semua Notifikasi</h5>

            <div className="d-flex align-items-center gap-2">
              {unreadCount > 0 && (
                <button
                  className="btn btn-sm btn-outline-primary d-flex align-items-center gap-2"
                  onClick={onMarkAllRead}
                >
                  <i className="bx bx-envelope-open"></i>
                  <span className="d-none d-md-inline">Tandai semua dibaca</span>
                </button>
              )}
              <button type="button" className="btn-close ms-2" onClick={onClose}></button>
            </div>
          </div>

          <div className="modal-body">
            {notifications.length > 0 ? (
              <ul className="list-group">
                {notifications.map((notif, i) => (
                  <li key={i} className="list-group-item">
                    <NotificationItem notif={notif} />
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-center text-muted">Tidak ada notifikasi</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default NotificationModal;
