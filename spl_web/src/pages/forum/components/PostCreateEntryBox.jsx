import React, { useState, useRef } from "react";
import { Form, Button, Toast, ToastContainer, Spinner } from "react-bootstrap";
import AvatarCircle from "./AvatarCircle"; // Ganti AvatarDisplay

const PostCreateEntryBox = ({ currentUser, onCreate }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const fileInputRef = useRef();
  const [toast, setToast] = useState({ show: false, message: "", variant: "danger" });

  const MAX_FILES = 10;

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
  };

  const triggerFileUpload = () => {
    if (fileInputRef.current) fileInputRef.current.click();
  };

  return (
    <div className="card p-3 mb-4">
      <div className="d-flex align-items-center mb-3">
        <AvatarCircle
          username={"A"}
          size={48}
          fontSize={18}
        />
        <Form onSubmit={handleSubmit} className="flex-grow-1 ms-2">
          <Form.Control
            as="textarea"
            rows={2}
            placeholder="Apa yang ingin kamu bagikan hari ini?"
            className="rounded-pill px-4 py-2"
            style={{ resize: "none" }}
            value={content}
            onChange={(e) => setContent(e.target.value)}
            disabled={isSubmitting}
          />
        </Form>
      </div>

      <Form onSubmit={handleSubmit} encType="multipart/form-data">
        <input
          type="file"
          accept="image/*"
          multiple
          ref={fileInputRef}
          onChange={handleFileChange}
          style={{ display: "none" }}
          disabled={isSubmitting}
        />

        <div className="d-flex justify-content-between align-items-center">
          <div className="d-flex text-muted small gap-3">
            <div className="d-flex align-items-center gap-1" role="button">
              <i className="bi bi-camera-video-fill text-success"></i>
              <span>Video</span>
            </div>
            <div
              className="d-flex align-items-center gap-1"
              role="button"
              onClick={triggerFileUpload}
            >
              <i className="bi bi-image-fill text-primary"></i>
              <span>Foto</span>
              {images.length > 0 && (
                <small className="text-muted ms-1">({images.length})</small>
              )}
            </div>
            <div className="d-flex align-items-center gap-1" role="button">
              <i className="bi bi-file-earmark-text-fill text-danger"></i>
              <span>Tulis artikel</span>
            </div>
          </div>

          <Button type="submit" variant="primary" size="sm" disabled={isSubmitting}>
            {isSubmitting ? (
              <>
                <Spinner size="sm" animation="border" className="me-2" />
                Mengirim...
              </>
            ) : (
              "Kirim"
            )}
          </Button>
        </div>
      </Form>

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
    </div>
  );
};

export default PostCreateEntryBox;
