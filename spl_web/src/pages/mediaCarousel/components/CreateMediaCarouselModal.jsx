// src/pages/carousel/components/CarouselCreateModal.jsx
import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";

const MediaCarouselCreateModal = ({ show, onHide, onCreate }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState(null);

  const [titleError, setTitleError] = useState("");
  const [imageError, setImageError] = useState("");

  useEffect(() => {
    if (show) {
      // Reset semua saat modal dibuka
      setTitle("");
      setDescription("");
      setImage(null);
      setTitleError("");
      setImageError("");
    }
  }, [show]);

  const handleSubmit = () => {
    let isValid = true;

    if (!title.trim()) {
      setTitleError("Judul wajib diisi.");
      isValid = false;
    } else {
      setTitleError("");
    }

    if (!image) {
      setImageError("Gambar wajib dipilih.");
      isValid = false;
    } else {
      setImageError("");
    }

    if (!isValid) return;

    const formData = new FormData();
    formData.append("title", title);
    formData.append("description", description);
    formData.append("image", image);

    onCreate(formData);
    onHide();
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Tambah Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          {/* Judul */}
          <Form.Group className="mb-3">
            <Form.Label>Judul</Form.Label>
            <Form.Control
              type="text"
              placeholder="Masukkan judul"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              isInvalid={!!titleError}
            />
            <Form.Control.Feedback type="invalid">
              {titleError}
            </Form.Control.Feedback>
          </Form.Group>

          {/* Deskripsi (Opsional) */}
          <Form.Group className="mb-3">
            <Form.Label>Deskripsi (Opsional)</Form.Label>
            <Form.Control
              as="textarea"
              rows={3}
              placeholder="Tulis deskripsi carousel..."
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </Form.Group>

          {/* Gambar */}
          <Form.Group className="mb-3">
            <Form.Label>Gambar</Form.Label>
            <Form.Control
              type="file"
              accept="image/*"
              onChange={(e) => setImage(e.target.files[0])}
              isInvalid={!!imageError}
            />
            <Form.Control.Feedback type="invalid">
              {imageError}
            </Form.Control.Feedback>
          </Form.Group>
        </Form>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Batal
        </Button>
        <Button variant="primary" onClick={handleSubmit}>
          Simpan
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default MediaCarouselCreateModal;
