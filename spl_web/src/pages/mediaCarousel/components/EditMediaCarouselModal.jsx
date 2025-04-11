import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";

const MediaCarouselEditModal = ({ show, onHide, mediaCarousel, onSave }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState(null);

  // Sinkronkan data saat modal dibuka atau mediaCarousel berubah
  useEffect(() => {
    if (mediaCarousel) {
      setTitle(mediaCarousel.title || "");
      setDescription(mediaCarousel.description || "");
      setImage(null); // Reset input file setiap kali modal dibuka
    }
  }, [mediaCarousel]);

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!title.trim() || !description.trim()) {
      alert("❌ Judul dan deskripsi wajib diisi.");
      return;
    }

    const formData = new FormData();
    formData.append("title", title.trim());
    formData.append("description", description.trim());
    if (image) formData.append("image", image);

    onSave(mediaCarousel.id, formData);
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">✏️ Edit Media Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form onSubmit={handleSubmit}>
          <Form.Group className="mb-3">
            <Form.Label>Judul</Form.Label>
            <Form.Control
              type="text"
              placeholder="Masukkan judul carousel"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Deskripsi</Form.Label>
            <Form.Control
              as="textarea"
              rows={4}
              placeholder="Tulis deskripsi carousel..."
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Gambar (opsional)</Form.Label>
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
                />
              </div>
            )}
          </Form.Group>

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
