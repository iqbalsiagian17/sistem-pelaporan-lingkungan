import { useState } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const AnnouncementCreateModal = ({ show, onHide, onCreate }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState(null);

  const handleSubmit = () => {
    if (!title.trim() || !description.trim()) {
      alert("Judul dan deskripsi wajib diisi.");
      return;
    }

    const formData = new FormData();
    formData.append("title", title);
    formData.append("description", description);
    if (file) formData.append("file", file);

    onCreate(formData);

    // Reset form setelah submit
    setTitle("");
    setDescription("");
    setFile(null);
    onHide();
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
            />
          </Form.Group>

          {/* Deskripsi */}
          <Form.Group className="mb-4">
            <Form.Label>Deskripsi</Form.Label>
            <div className="border rounded" style={{ minHeight: "250px", overflow: "hidden" }}>
              <ReactQuill
                theme="snow"
                value={description}
                onChange={setDescription}
                placeholder="Tulis deskripsi pengumuman..."
                style={{ height: "220px", border: "none" }}
              />
            </div>
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
