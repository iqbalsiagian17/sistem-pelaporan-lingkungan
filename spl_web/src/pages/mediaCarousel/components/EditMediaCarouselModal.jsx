import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";

const MediaCarouselEditModal = ({ show, onHide, mediaCarousel, onSave }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState(null);
  const [titleError, setTitleError] = useState("");

  // Sinkronkan data saat modal dibuka
  useEffect(() => {
    if (mediaCarousel) {
      setTitle(mediaCarousel.title || "");
      setDescription(mediaCarousel.description || "");
      setImage(null);
      setTitleError("");
    }
  }, [mediaCarousel]);

  const handleSubmit = (e) => {
    e.preventDefault();

    let isValid = true;
    if (!title.trim()) {
      setTitleError("Judul tidak boleh kosong.");
      isValid = false;
    } else {
      setTitleError("");
    }

    if (!isValid) return;

    const formData = new FormData();
    formData.append("title", title.trim());
    formData.append("description", description.trim());
    if (image) formData.append("image", image);

    onSave(mediaCarousel.id, formData);
  };

  const handleImageError = (e) => {
    e.target.onerror = null;
    e.target.src = "/assets/img/illustrations/error-image.png";
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Edit Media Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form onSubmit={handleSubmit}>
          {/* Judul */}
          <Form.Group className="mb-3">
            <Form.Label>Judul</Form.Label>
            <Form.Control
              type="text"
              placeholder="Masukkan judul carousel"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              isInvalid={!!titleError}
            />
            <Form.Control.Feedback type="invalid">
              {titleError}
            </Form.Control.Feedback>
          </Form.Group>

          {/* Deskripsi (opsional) */}
          <Form.Group className="mb-3">
            <Form.Label>Deskripsi (Opsional)</Form.Label>
            <Form.Control
              as="textarea"
              rows={4}
              placeholder="Tulis deskripsi carousel..."
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </Form.Group>

          {/* Gambar */}
          <Form.Group className="mb-3">
            <Form.Label>Gambar (Opsional)</Form.Label>
            <Form.Control
              type="file"
              accept="image/*"
              onChange={(e) => setImage(e.target.files[0])}
            />

            {!image && mediaCarousel?.image && (
              <div className="mt-3">
                <Form.Label>Pratinjau Gambar Saat Ini</Form.Label>
                <br />
                <img
                  src={`http://localhost:3000/${mediaCarousel.image}`}
                  alt="Preview"
                  className="img-fluid rounded shadow-sm border"
                  style={{ maxHeight: "180px", objectFit: "cover" }}
                  onError={handleImageError}
                />
              </div>
            )}
          </Form.Group>

          {/* Tombol */}
          <div className="text-end">
            <Button variant="secondary" onClick={onHide} className="me-2">
              Batal
            </Button>
            <Button variant="primary" type="submit">
              Simpan Perubahan
            </Button>
          </div>
        </Form>
      </Modal.Body>
    </Modal>
  );
};

export default MediaCarouselEditModal;
