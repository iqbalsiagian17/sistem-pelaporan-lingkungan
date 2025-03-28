import React from "react";
import { useNavigate } from "react-router-dom";
import { markNotificationAsRead } from "../../services/notificationService";

const NotificationItem = ({ notif }) => {
  const navigate = useNavigate();

  const handleClick = async () => {
    await markNotificationAsRead(notif.id);

    if (notif.type === "report" || notif.type === "status_change") {
      window.location.href = "/reports"; // ✅ langsung reload halaman laporan
    } else if (notif.type === "account") {
      window.location.href = "/users"; // ✅ langsung reload halaman pengguna
    } else {
      window.location.href = "/notifications"; // fallback
    }  
  };

  const getIcon = () => {
    if (notif.type === "report") return "bx bx-file text-primary";
    if (notif.type === "status_change") return "bx bx-refresh text-warning";
    if (notif.type === "account") return "bx bx-user-plus text-success";
    return "bx bx-bell text-info";
  };

  return (
    <div
      className={`list-group-item list-group-item-action dropdown-notifications-item d-flex border-0 p-3 mb-1 rounded shadow-sm ${
        notif.is_read
          ? "bg-white text-muted"
          : "bg-light border-start border-4 border-primary"
      }`}
      onClick={handleClick}
      style={{ cursor: "pointer", opacity: notif.is_read ? 0.85 : 1 }}
    >
      <div className="flex-shrink-0 me-3">
        <div className="avatar">
          <span className="avatar-initial rounded-circle bg-label-secondary">
            <i className={`icon-base ${getIcon()}`}></i>
          </span>
        </div>
      </div>
      <div className="flex-grow-1">
        <h6 className={`mb-1 small ${!notif.is_read ? "fw-bold text-dark" : "text-muted"}`}>
          {notif.title}
        </h6>
        <small className="d-block">{notif.message}</small>
        <small className="text-secondary">
          {new Date(notif.createdAt).toLocaleString("id-ID")}
        </small>
      </div>
      {!notif.is_read && (
        <div className="flex-shrink-0 ms-2 d-flex align-items-center">
          <span className="badge bg-danger rounded-circle" style={{ width: 10, height: 10 }}></span>
        </div>
      )}
    </div>
  );
};

export default NotificationItem;
