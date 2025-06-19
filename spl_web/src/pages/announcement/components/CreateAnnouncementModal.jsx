import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const AnnouncementCreateModal = ({ show, onHide, onCreate }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState(null);
  const [titleError, setTitleError] = useState("");
  const [descriptionError, setDescriptionError] = useState("");

  useEffect(() => {
    if (show) {
      // Reset ketika modal dibuka
      setTitle("");
      setDescription("");
      setFile(null);
      setTitleError("");
      setDescriptionError("");
    }
  }, [show]);

  const handleSubmit = () => {
    let valid = true;

    if (!title.trim()) {
      setTitleError("Judul tidak boleh kosong.");
      valid = false;
    } else {
      setTitleError("");
    }

    const descPlain = description.replace(/<(.|\n)*?>/g, "").trim();
    if (!descPlain) {
      setDescriptionError("Deskripsi tidak boleh kosong.");
      valid = false;
    } else {
      setDescriptionError("");
    }

    if (!valid) return;

    const formData = new FormData();
    formData.append("title", title);
    formData.append("description", description);
    if (file) formData.append("file", file);

    onCreate(formData);
    onHide(); // Tutup modal setelah berhasil
  };

  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Tambah Pengumuman</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <Form>
          {/* Judul */}
          <Form.Group className="mb-3">
            <Form.Label>Judul Pengumuman</Form.Label>
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

          {/* Deskripsi */}
          <Form.Group className="mb-4">
            <Form.Label>Deskripsi</Form.Label>
            <div className={`border rounded ${descriptionError ? 'border-danger' : ''}`} style={{ minHeight: "250px", overflow: "hidden" }}>
              <ReactQuill
                theme="snow"
                value={description}
                onChange={setDescription}
                placeholder="Tulis deskripsi pengumuman..."
                style={{ height: "220px", border: "none" }}
              />
            </div>
            {descriptionError && (
              <div className="text-danger mt-1" style={{ fontSize: "0.875em" }}>
                {descriptionError}
              </div>
            )}
          </Form.Group>

          {/* Lampiran */}
          <Form.Group className="mb-3">
            <Form.Label>Lampiran (Opsional)</Form.Label>
            <Form.Control
              type="file"
              onChange={(e) => setFile(e.target.files[0])}
            />
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

export default AnnouncementCreateModal;
