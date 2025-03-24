// src/pages/carousel/components/CarouselEditModal.jsx
import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const CarouselEditModal = ({ show, onHide, carousel, onSave }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState(null);

  // Sinkronisasi data saat modal dibuka atau carousel berubah
  useEffect(() => {
    if (carousel) {
      setTitle(carousel.title || "");
      setDescription(carousel.description || "");
      setImage(null); // reset upload
    }
  }, [carousel]);

  const handleSubmit = () => {
    if (!title || !description) {
      alert("❌ Judul dan deskripsi wajib diisi.");
      return;
    }

    const formData = new FormData();
    formData.append("title", title);
    formData.append("description", description);
    if (image) formData.append("image", image);

    onSave(carousel.id, formData);
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">✏️ Edit Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
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
            <div style={{ height: "300px" }}>
              <ReactQuill
                theme="snow"
                value={description}
                onChange={setDescription}
                placeholder="Tulis deskripsi carousel..."
                style={{ height: "100%" }}
              />
            </div>
          </Form.Group>
          <Form.Group>
            <Form.Label>Gambar</Form.Label>
            <Form.Control type="file" onChange={(e) => setImage(e.target.files[0])} />

            {!image && carousel?.image && (
                <div className="mt-3">
                <Form.Label>Pratinjau Gambar Saat Ini</Form.Label>
                <br />
                <img
                    src={`http://localhost:3000/${carousel.image}`}
                    alt="Preview"
                    className="img-fluid rounded shadow-sm border"
                    style={{ maxHeight: "180px", objectFit: "cover" }}
                />
                </div>
            )}
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
  );
};

export default CarouselEditModal;
