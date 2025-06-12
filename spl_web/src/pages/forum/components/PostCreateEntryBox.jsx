import React, { useState, useRef } from "react";
import { Form, Button, Spinner } from "react-bootstrap";
import AvatarCircle from "./AvatarCircle";

const PostCreateEntryBox = ({ currentUser, onCreate, showToast }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [contentError, setContentError] = useState(""); // 🔥 Validasi teks
  const fileInputRef = useRef();

  const MAX_FILES = 10;

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!content.trim()) {
      setContentError("Konten tidak boleh kosong");
      return;
    } else {
      setContentError("");
    }

    if (images.length > MAX_FILES) {
      showToast(`❌ Maksimal ${MAX_FILES} gambar diperbolehkan.`, "danger");
      return;
    }

    setIsSubmitting(true);
    const formData = new FormData();
    formData.append("content", content.trim());
    images.forEach((file) => formData.append("images", file));

    try {
      await onCreate(formData);
      resetForm();
    } catch (error) {
      showToast("❌ Gagal mengirim postingan!", "danger");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleFileChange = (e) => {
    const selected = Array.from(e.target.files);
    if (selected.length > MAX_FILES) {
      showToast(`❌ Maksimal ${MAX_FILES} gambar diperbolehkan.`, "danger");
      e.target.value = null;
      return;
    }
    setImages(selected);
  };

  const resetForm = () => {
    setContent("");
    setImages([]);
    setContentError("");
    if (fileInputRef.current) fileInputRef.current.value = null;
  };

  const triggerFileUpload = () => {
    if (fileInputRef.current) fileInputRef.current.click();
  };

  return (
    <div className="card p-3 mb-2">
      <div className="d-flex align-items-center mb-3">
        <AvatarCircle username={currentUser?.username || "A"} size={48} fontSize={18} />
        <Form onSubmit={handleSubmit} className="flex-grow-1 ms-2">
          <Form.Control
            as="textarea"
            rows={2}
            placeholder="Apa yang ingin kamu bagikan hari ini?"
            className="px-4 py-2"
            style={{ resize: "none" }}
            value={content}
            isInvalid={!!contentError}
            onChange={(e) => {
              setContent(e.target.value);
              if (e.target.value.trim()) setContentError("");
            }}
            disabled={isSubmitting}
          />
          <Form.Control.Feedback type="invalid">{contentError}</Form.Control.Feedback>
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
    </div>
  );
};

export default PostCreateEntryBox;
