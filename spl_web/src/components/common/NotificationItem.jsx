// NotificationItem.jsx
import React from "react";
import { useNavigate } from "react-router-dom";
import { markNotificationAsRead } from "../../services/notificationService";

const NotificationItem = ({ notif }) => {
  const navigate = useNavigate();

  const handleClick = async () => {
    await markNotificationAsRead(notif.id);

    if (notif.type === "report") {
      navigate("/reports");
    } else if (notif.type === "status_change") {
      navigate("/reports");
    } else if (notif.type === "account") {
      navigate("/users");
    } else {
      navigate("/notifications");
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
      className={`list-group-item list-group-item-action dropdown-notifications-item ${
        notif.is_read ? "marked-as-read" : ""
      }`}
      onClick={handleClick}
      style={{ cursor: "pointer" }}
    >
      <div className="d-flex">
        <div className="flex-shrink-0 me-3">
          <div className="avatar">
            <span className="avatar-initial rounded-circle bg-label-secondary">
              <i className={`icon-base ${getIcon()}`}></i>
            </span>
          </div>
        </div>
        <div className="flex-grow-1">
          <h6 className="small mb-0">{notif.title}</h6>
          <small className="mb-1 d-block text-body">{notif.message}</small>
          <small className="text-body-secondary">
            {new Date(notif.createdAt).toLocaleString("id-ID")}
          </small>
        </div>
        <div className="flex-shrink-0 dropdown-notifications-actions">
          {!notif.is_read && (
            <a href="#" className="dropdown-notifications-read">
              <span className="badge badge-dot"></span>
            </a>
          )}
          <a href="#" className="dropdown-notifications-archive">
            <span className="icon-base bx bx-x"></span>
          </a>
        </div>
      </div>
    </div>
  );
};

export default NotificationItem;
