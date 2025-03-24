// src/pages/user/components/UserBlockModal.jsx
import { Modal, Button, Form } from "react-bootstrap";

const UserBlockModal = ({ show, onHide, onConfirm, blockingUntil, setBlockingUntil }) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>🚫 Blokir Pengguna</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form.Group>
          <Form.Label>Tanggal hingga diblokir</Form.Label>
          <Form.Control
            type="date"
            value={blockingUntil}
            onChange={(e) => setBlockingUntil(e.target.value)}
          />
        </Form.Group>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="warning" onClick={onConfirm}>Blokir</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserBlockModal;
