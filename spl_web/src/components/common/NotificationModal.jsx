import React from "react";
import NotificationItem from "./NotificationItem";

const NotificationModal = ({ show, onClose, notifications }) => {
  if (!show) return null;

  return (
    <div className="modal fade show d-block" style={{ backgroundColor: "rgba(0,0,0,0.5)" }}>
      <div className="modal-dialog modal-lg modal-dialog-scrollable">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">Semua Notifikasi</h5>
            <button type="button" className="btn-close" onClick={onClose}></button>
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
