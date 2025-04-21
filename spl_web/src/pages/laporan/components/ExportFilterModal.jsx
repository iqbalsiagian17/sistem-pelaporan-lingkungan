import { Modal, Button, Form } from "react-bootstrap";
import { useState } from "react";
import statusData from "../../../data/statusData.json";

const ExportFilterModal = ({ show, onClose, onExport }) => {
  const [selectedStatus, setSelectedStatus] = useState("");
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const [locationFilter, setLocationFilter] = useState(""); // ⬅️ Lokasi filter

  const statusOptions = Object.entries(statusData.statusMappings);

  const handleSubmit = () => {
    onExport({ status: selectedStatus, dateFrom, dateTo, location: locationFilter });
    onClose();
  };

  return (
    <Modal show={show} onHide={onClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Filter Data Sebelum Export</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          {/* ✅ Status */}
          <Form.Group className="mb-3">
            <Form.Label>Status</Form.Label>
            <Form.Select
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value)}
            >
              <option value="">Semua Status</option>
              {statusOptions.map(([key, value]) => (
                <option key={key} value={key}>
                  {value.label}
                </option>
              ))}
            </Form.Select>
          </Form.Group>

          {/* ✅ Dari Tanggal */}
          <Form.Group className="mb-3">
            <Form.Label>Dari Tanggal</Form.Label>
            <Form.Control
              type="date"
              value={dateFrom}
              onChange={(e) => setDateFrom(e.target.value)}
            />
          </Form.Group>

          {/* ✅ Sampai Tanggal */}
          <Form.Group className="mb-3">
            <Form.Label>Sampai Tanggal</Form.Label>
            <Form.Control
              type="date"
              value={dateTo}
              onChange={(e) => setDateTo(e.target.value)}
            />
          </Form.Group>

          {/* ✅ Lokasi */}
          <Form.Group className="mb-3">
            <Form.Label>Lokasi</Form.Label>
            <Form.Select
              value={locationFilter}
              onChange={(e) => setLocationFilter(e.target.value)}
            >
              <option value="">Semua Lokasi</option>
              <option value="with_location">Di Lokasi (Ada Koordinat)</option>
              <option value="without_location">Tidak di Lokasi (Tidak Ada Koordinat)</option>
            </Form.Select>
          </Form.Group>
          
        </Form>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onClose}>
          Batal
        </Button>
        <Button variant="success" onClick={handleSubmit}>
          Export
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ExportFilterModal;
