import React, { useEffect, useState } from "react";
import { Modal, Form, Button, Toast, ToastContainer } from "react-bootstrap";

const CommentEditModal = ({ show, onHide, onSave, comment }) => {
  const [content, setContent] = useState("");
  const [toast, setToast] = useState({ show: false, message: "", variant: "danger" });

  useEffect(() => {
    if (comment) {
      setContent(comment.content || "");
    }
  }, [comment]);

  const showToast = (message, variant = "danger") => {
    setToast({ show: true, message, variant });
    setTimeout(() => setToast({ show: false, message: "", variant }), 3000);
  };

  const handleSubmit = () => {
    if (!content.trim()) {
      showToast("Komentar tidak boleh kosong.");
      return;
    }
    onSave(comment.id, content.trim());
    onHide();
  };

  return (
    <>
      <Modal show={show} onHide={onHide} centered>
        <Modal.Header closeButton>
          <Modal.Title>✏️ Edit Komentar</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group>
              <Form.Label>Isi Komentar</Form.Label>
              <Form.Control
                as="textarea"
                rows={3}
                value={content}
                onChange={(e) => setContent(e.target.value)}
                placeholder="Edit komentar..."
              />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={onHide}>
            Batal
          </Button>
          <Button variant="primary" onClick={handleSubmit}>
            Simpan Perubahan
          </Button>
        </Modal.Footer>
      </Modal>

      <ToastContainer position="bottom-end" className="p-3" style={{ zIndex: 9999 }}>
        <Toast
          onClose={() => setToast({ ...toast, show: false })}
          show={toast.show}
          bg={toast.variant}
          delay={3000}
          autohide
        >
          <Toast.Body className="text-white">{toast.message}</Toast.Body>
        </Toast>
      </ToastContainer>
    </>
  );
};

export default CommentEditModal;
