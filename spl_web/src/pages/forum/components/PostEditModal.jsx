import React, { useState, useEffect, useRef } from "react";
import { Modal, Button, Form, Toast, ToastContainer, Spinner } from "react-bootstrap";

const PostEditModal = ({ show, onHide, onSave, initialData }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const fileInputRef = useRef();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [toast, setToast] = useState({ show: false, message: "", variant: "danger" });

  const MAX_FILES = 2;

  useEffect(() => {
    if (initialData) {
      setContent(initialData.content || "");
      setImages([]);
    }
  }, [initialData]);

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
      await onSave(formData);
      resetForm();
    } catch (err) {
      showToast("❌ Gagal mengedit postingan!");
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
          <Modal.Title>✏️ Edit Postingan</Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleSubmit} encType="multipart/form-data">
          <Modal.Body>
            <Form.Group>
              <Form.Label>Konten</Form.Label>
              <Form.Control
                as="textarea"
                rows={4}
                placeholder="Edit konten postingan..."
                value={content}
                onChange={(e) => setContent(e.target.value)}
                required
                disabled={isSubmitting}
              />
            </Form.Group>

            {initialData?.images?.length > 0 && (
              <div className="mt-3">
                <Form.Label>Gambar Saat Ini</Form.Label>
                <div className="d-flex flex-wrap gap-2">
                  {initialData.images.map((img) => (
                    <img
                      key={img.id}
                      src={`https://baligebersih.site/${img.image}`}
                      alt="existing"
                      style={{
                        width: "100px",
                        height: "100px",
                        objectFit: "cover",
                        borderRadius: 8,
                      }}
                    />
                  ))}
                </div>
              </div>
            )}

            <Form.Group className="mt-3">
              <Form.Label>Ganti Gambar (maksimal {MAX_FILES})</Form.Label>
              <Form.Control
                type="file"
                accept="image/*"
                multiple
                ref={fileInputRef}
                onChange={handleFileChange}
                disabled={isSubmitting}
              />
              <Form.Text muted>
                Mengunggah gambar baru akan menggantikan gambar yang lama.
              </Form.Text>
              {images.length > 0 && (
                <small className="text-muted d-block mt-1">
                  {images.length} file baru dipilih
                </small>
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
                  Menyimpan...
                </>
              ) : (
                "Simpan Perubahan"
              )}
            </Button>
          </Modal.Footer>
        </Form>
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

export default PostEditModal;
