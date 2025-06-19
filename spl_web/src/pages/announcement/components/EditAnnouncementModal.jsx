import { Modal, Button, Form } from "react-bootstrap";
import { useState, useEffect } from "react";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const AnnouncementEditModal = ({ show, onHide, announcement, onSave }) => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState(null);
  const [titleError, setTitleError] = useState("");
  const [descriptionError, setDescriptionError] = useState("");

  // Reset field saat modal terbuka atau data berubah
  useEffect(() => {
    if (announcement) {
      setTitle(announcement.title || "");
      setDescription(announcement.description || "");
      setFile(null);
      setTitleError("");
      setDescriptionError("");
    }
  }, [announcement]);

  const handleSave = () => {
    let valid = true;

    if (!title.trim()) {
      setTitleError("Judul tidak boleh kosong.");
      valid = false;
    } else {
      setTitleError("");
    }

    // Validasi deskripsi dengan membersihkan tag kosong
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

    onSave(announcement.id, formData);
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">✏️ Edit Pengumuman</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          {/* Judul */}
          <Form.Group className="mb-3">
            <Form.Label>Judul</Form.Label>
            <Form.Control
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Masukkan judul"
              isInvalid={!!titleError}
            />
            <Form.Control.Feedback type="invalid">
              {titleError}
            </Form.Control.Feedback>
          </Form.Group>

          {/* Deskripsi */}
          <Form.Group className="mb-3">
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
          <Form.Group>
            <Form.Label>Lampiran (Opsional)</Form.Label>
            <Form.Control
              type="file"
              onChange={(e) => setFile(e.target.files[0])}
            />
            {!file && announcement?.file && (
              <small className="text-muted d-block mt-1">
                File saat ini:{" "}
                <a
                  href={`http://localhost:3000/${announcement.file}`}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  {announcement.file.split("/").pop()}
                </a>
              </small>
            )}
          </Form.Group>
        </Form>
      </Modal.Body>

      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Batal
        </Button>
        <Button variant="primary" onClick={handleSave}>
          Simpan Perubahan
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default AnnouncementEditModal;
