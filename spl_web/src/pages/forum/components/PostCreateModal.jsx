import React, { useState, useRef } from "react";
import { Modal, Button, Form, Toast, ToastContainer } from "react-bootstrap";

const PostCreateModal = ({ show, onHide, onCreate }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const fileInputRef = useRef();
  const [toast, setToast] = useState({ show: false, message: "", variant: "danger" });

  const MAX_FILES = 5;
  const MAX_SIZE_MB = 25;

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
      showToast(`❌ Maksimal ${MAX_FILES} gambar yang diperbolehkan.`);
      return;
    }

    for (const img of images) {
      if (img.size > MAX_SIZE_MB * 1024 * 1024) {
        showToast(`❌ Ukuran gambar tidak boleh melebihi ${MAX_SIZE_MB}MB.`);
        return;
      }
    }

    const formData = new FormData();
    formData.append("content", content);
    images.forEach((file) => formData.append("images", file));

    await onCreate(formData);
    resetForm();
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
              />
            </Form.Group>

            <Form.Group className="mt-3">
              <Form.Label>Gambar (maksimal 5 × 25MB)</Form.Label>
              <Form.Control
                type="file"
                accept="image/*"
                multiple
                ref={fileInputRef}
                onChange={handleFileChange}
              />
              {images.length > 0 && (
                <small className="text-muted">{images.length} file dipilih</small>
              )}
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={resetForm}>
              Batal
            </Button>
            <Button type="submit" variant="primary">
              Kirim
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>

      <ToastContainer
        position="bottom-end"
        className="p-3"
        style={{ zIndex: 9999, position: "fixed" }} // ✅ zIndex tinggi + posisi fixed
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
