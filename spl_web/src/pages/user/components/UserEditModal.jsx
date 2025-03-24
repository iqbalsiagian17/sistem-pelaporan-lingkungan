import { Modal, Button, Form } from "react-bootstrap";
import { useState, useEffect } from "react";

const UserEditModal = ({ show, onHide, user, onSave }) => {
  const [formData, setFormData] = useState({ username: "", email: "", phone_number: "" });

  useEffect(() => {
    if (user) {
      setFormData({
        username: user.username || "",
        email: user.email || "",
        phone_number: user.phone_number || ""
      });
    }
  }, [user]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = () => {
    onSave(user.id, formData);
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>✏️ Edit Pengguna</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form.Group className="mb-3">
          <Form.Label>Username</Form.Label>
          <Form.Control name="username" value={formData.username} onChange={handleChange} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Email</Form.Label>
          <Form.Control name="email" value={formData.email} onChange={handleChange} />
        </Form.Group>
        <Form.Group>
          <Form.Label>No HP</Form.Label>
          <Form.Control name="phone_number" value={formData.phone_number} onChange={handleChange} />
        </Form.Group>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="primary" onClick={handleSubmit}>Simpan</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserEditModal;
