import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import MapBoundaryEditor from "./MapBoundaryEditor";

const EditVillageModal = ({ show, onHide, village, onSave }) => {
  const [name, setName] = useState("");
  const [boundary, setBoundary] = useState(null);
  const [nameError, setNameError] = useState("");

  useEffect(() => {
    if (show && village) {
      setName(village.name || "");
      setBoundary(village.boundary || null);
      setNameError("");
    }
  }, [show, village]);

  const handleSubmit = () => {
    if (!name.trim()) {
      setNameError("Nama desa wajib diisi.");
      return;
    }

    const payload = {
      name: name.trim(),
      boundary,
    };

    onSave(village.id, payload);
  };

  return (
    <Modal show={show} onHide={onHide} size="xl" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Edit Desa</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          <Form.Group className="mb-3">
            <Form.Label>Nama Desa</Form.Label>
            <Form.Control
              type="text"
              placeholder="Masukkan nama desa"
              value={name}
              onChange={(e) => setName(e.target.value)}
              isInvalid={!!nameError}
            />
            <Form.Control.Feedback type="invalid">
              {nameError}
            </Form.Control.Feedback>
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Gambar Batas Wilayah Desa</Form.Label>
            <MapBoundaryEditor
              initialPolygon={boundary}
              onPolygonCreated={(geojson) => setBoundary(geojson)}
            />
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

export default EditVillageModal;
