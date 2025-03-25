import { useState } from "react";
import { Modal, Button, Form, Row, Col } from "react-bootstrap";

const CreateParameterModal = ({ show, onHide, onCreate }) => {
  const [form, setForm] = useState({
    about: "",
    terms: "",
    report_guidelines: "",
    emergency_contact: "",
    ambulance_contact: "",
    police_contact: "",
    firefighter_contact: "",
  });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = () => {
    // Validasi sederhana
    if (!form.about || !form.terms || !form.report_guidelines) {
      alert("❌ Harap lengkapi kolom utama (About, Terms, Guidelines)");
      return;
    }

    onCreate(form);
    onHide();
    setForm({
      about: "",
      terms: "",
      report_guidelines: "",
      emergency_contact: "",
      ambulance_contact: "",
      police_contact: "",
      firefighter_contact: "",
    });
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered scrollable>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Tambah Parameter</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          <Form.Group className="mb-3">
            <Form.Label>About</Form.Label>
            <Form.Control
              as="textarea"
              rows={2}
              name="about"
              value={form.about}
              onChange={handleChange}
              placeholder="Tentang aplikasi..."
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Terms</Form.Label>
            <Form.Control
              as="textarea"
              rows={2}
              name="terms"
              value={form.terms}
              onChange={handleChange}
              placeholder="Syarat & Ketentuan..."
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Panduan Pelaporan</Form.Label>
            <Form.Control
              as="textarea"
              rows={2}
              name="report_guidelines"
              value={form.report_guidelines}
              onChange={handleChange}
              placeholder="Tata cara pelaporan..."
            />
          </Form.Group>

          <Row>
            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Kontak Darurat</Form.Label>
                <Form.Control
                  type="text"
                  name="emergency_contact"
                  value={form.emergency_contact}
                  onChange={handleChange}
                  placeholder="08xxxx / 112 / lainnya"
                />
              </Form.Group>
            </Col>

            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Ambulans</Form.Label>
                <Form.Control
                  type="text"
                  name="ambulance_contact"
                  value={form.ambulance_contact}
                  onChange={handleChange}
                  placeholder="08xxxx / 119 / lainnya"
                />
              </Form.Group>
            </Col>
          </Row>

          <Row>
            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Polisi</Form.Label>
                <Form.Control
                  type="text"
                  name="police_contact"
                  value={form.police_contact}
                  onChange={handleChange}
                  placeholder="110 / kontak polisi"
                />
              </Form.Group>
            </Col>

            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Pemadam Kebakaran</Form.Label>
                <Form.Control
                  type="text"
                  name="firefighter_contact"
                  value={form.firefighter_contact}
                  onChange={handleChange}
                  placeholder="113 / kontak damkar"
                />
              </Form.Group>
            </Col>
          </Row>
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

export default CreateParameterModal;
