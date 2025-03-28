import { Toast, ToastContainer } from "react-bootstrap";

const ToastNotification = ({
  show,
  onClose,
  title = "Notifikasi",
  time = "Baru saja",
  message = "Ini pesan toast",
  variant = "success"
}) => {
  const bgColor = variant === "danger" ? "#f44336" : "#4caf50"; // merah atau hijau

  return (
    <ToastContainer
      position="bottom-end"
      className="p-3"
      style={{
        position: "fixed",
        bottom: 20,
        right: 20,
        zIndex: 9999,
      }}
    >
      <Toast
        show={show}
        onClose={onClose}
        delay={3000}
        autohide
        style={{
          minWidth: 320,
          borderRadius: 8,
          boxShadow: "0 8px 16px rgba(0,0,0,0.15)",
          borderLeft: `5px solid ${bgColor}`,
        }}
      >
        <div className="toast-header">
          <img
            src="/assets/img/logo/logo.png"
            className="rounded me-2"
            alt="icon"
            width={16}
            height={16}
          />
          <strong className="me-auto">{title}</strong>
          <small>{time}</small>
          <button
            type="button"
            className="btn-close ms-2 mb-1"
            aria-label="Close"
            onClick={onClose}
          />
        </div>
        <div className="toast-body">{message}</div>
      </Toast>
    </ToastContainer>
  );
};

export default ToastNotification;
