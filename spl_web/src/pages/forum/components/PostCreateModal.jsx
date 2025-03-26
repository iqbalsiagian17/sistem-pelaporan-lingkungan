import React, { useState } from "react";
import { Modal, Button, Form } from "react-bootstrap";

const PostCreateModal = ({ show, onHide, onCreate }) => {
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!content.trim()) {
      alert("Konten tidak boleh kosong!");
      return;
    }

    const formData = new FormData();
    formData.append("content", content);
    images.forEach((file) => formData.append("images", file));

    await onCreate(formData);
    setContent("");
    setImages([]);
  };

  const handleFileChange = (e) => {
    setImages([...e.target.files]);
  };

  const handleClose = () => {
    setContent("");
    setImages([]);
    onHide();
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>📝 Buat Postingan Baru</Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit} encType="multipart/form-data">
        <Modal.Body>
          <Form.Group>
            <Form.Label>Konten</Form.Label>
            <Form.Control
              as="textarea"
              rows={4}
              placeholder="Apa yang ingin kamu bagikan hari ini?"
              value={content}
              onChange={(e) => setContent(e.target.value)}
              required
              className="border border-gray-300 p-2 rounded-md text-sm"
            />
          </Form.Group>

          <Form.Group className="mt-3">
            <Form.Label>Gambar (max 5)</Form.Label>
            <Form.Control
              type="file"
              accept="image/*"
              multiple
              onChange={handleFileChange}
              className="border border-gray-300 p-2 rounded-md text-sm"
            />
            {images.length > 0 && (
              <small className="text-muted">{images.length} file dipilih</small>
            )}
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            Batal
          </Button>
          <Button type="submit" variant="primary">
            Kirim
          </Button>
        </Modal.Footer>
      </Form>
    </Modal>
  );
};

export default PostCreateModal;
