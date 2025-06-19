// src/pages/user/components/UserBlockModal.jsx
import { Modal, Button, Form } from "react-bootstrap";
import { useState, useEffect } from "react";

const UserBlockModal = ({ show, onHide, onConfirm, blockingUntil, setBlockingUntil }) => {
  const [error, setError] = useState("");

  const today = new Date().toISOString().split("T")[0]; // Format YYYY-MM-DD

  const handleConfirm = () => {
    if (!blockingUntil || blockingUntil < today) {
      setError("Tanggal harus hari ini atau lebih baru.");
      return;
    }
    setError("");
    onConfirm(); // jalankan fungsi blokir
  };

  useEffect(() => {
    if (show) setError(""); // reset error saat modal dibuka
  }, [show]);

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>Blokir Pengguna</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form.Group>
          <Form.Label>Tanggal hingga diblokir</Form.Label>
          <Form.Control
            type="date"
            min={today}
            value={blockingUntil}
            onChange={(e) => setBlockingUntil(e.target.value)}
            isInvalid={!!error}
          />
          <Form.Control.Feedback type="invalid">{error}</Form.Control.Feedback>
        </Form.Group>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="warning" onClick={handleConfirm}>Blokir</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserBlockModal;
