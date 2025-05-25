import React, { useState, useRef } from "react";
import { Modal, Button, Form, Toast, ToastContainer, Spinner } from "react-bootstrap";

const PostCreateModal = ({ show, onHide, onCreate }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const fileInputRef = useRef();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [toast, setToast] = useState({ show: false, message: "", variant: "danger" });

  const MAX_FILES = 2; // ✅ Batas hanya 2 gambar

  const showToast = (message, variant = "danger") => {
    setToast({ show: true, message, variant });
    setTimeout(() => setToast({ show: false, message: "", variant }), 3000);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!content.trim()) {
      showToast("❌ Konten tidak boleh kosong!");
      return;
    }

    if (images.length > MAX_FILES) {
      showToast(`❌ Maksimal ${MAX_FILES} gambar diperbolehkan.`);
      return;
    }

    setIsSubmitting(true);
    const formData = new FormData();
    formData.append("content", content);
    images.forEach((file) => formData.append("images", file));

    try {
      await onCreate(formData);
      resetForm();
    } catch (error) {
      showToast("❌ Gagal mengirim postingan!");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleFileChange = (e) => {
    const selected = Array.from(e.target.files);
    if (selected.length > MAX_FILES) {
      showToast(`❌ Maksimal ${MAX_FILES} gambar diperbolehkan.`);
      e.target.value = null;
      return;
    }
    setImages(selected);
  };

  const resetForm = () => {
    setContent("");
    setImages([]);
    if (fileInputRef.current) fileInputRef.current.value = null;
    onHide();
    setIsSubmitting(false);
  };

  return (
    <>
      <Modal show={show} onHide={resetForm} centered>
        <Modal.Header closeButton>
          <Modal.Title>📝 Buat Postingan Baru</Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleSubmit} encType="multipart/form-data">
          <Modal.Body>
            <Form.Group>
              <Form.Label>Konten</Form.Label>
              <Form.Control
                as="textarea"
                rows={4}
                placeholder="Apa yang ingin kamu bagikan hari ini?"
                value={content}
                onChange={(e) => setContent(e.target.value)}
                required
                disabled={isSubmitting}
              />
            </Form.Group>

            <Form.Group className="mt-3">
              <Form.Label>Gambar (maksimal {MAX_FILES})</Form.Label>
              <Form.Control
                type="file"
                accept="image/*"
                multiple
                ref={fileInputRef}
                onChange={handleFileChange}
                disabled={isSubmitting}
              />
              {images.length > 0 && (
                <small className="text-muted">{images.length} file dipilih</small>
              )}
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={resetForm} disabled={isSubmitting}>
              Batal
            </Button>
            <Button type="submit" variant="primary" disabled={isSubmitting}>
              {isSubmitting ? (
                <>
                  <Spinner size="sm" animation="border" className="me-2" />
                  Mengirim...
                </>
              ) : (
                "Kirim"
              )}
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>

      <ToastContainer
        position="bottom-end"
        className="p-3"
        style={{ zIndex: 9999, position: "fixed" }}
      >
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


export default PostCreateModal;
