import { useState } from "react";
import { Modal, Button, Form } from "react-bootstrap";

const UserChangePasswordModal = ({ show, onHide, user, onConfirm }) => {
  const [password, setPassword] = useState("");

  const handleSubmit = () => {
    if (!password.trim()) return alert("Password tidak boleh kosong");
    onConfirm(user.id, password);
    setPassword("");
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>Ganti Password - {user?.username}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form.Group>
          <Form.Label>Password Baru</Form.Label>
          <Form.Control
            type="password"
            placeholder="Masukkan password baru"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </Form.Group>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="primary" onClick={handleSubmit}>Simpan</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserChangePasswordModal;
