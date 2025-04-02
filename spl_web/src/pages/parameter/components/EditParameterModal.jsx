import { useState, useEffect } from "react";
import { Modal, Button, Form, Row, Col } from "react-bootstrap";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const EditParameterModal = ({ show, onHide, parameter, onSave }) => {
  const [form, setForm] = useState({
    about: "",
    terms: "",
    report_guidelines: "",
    emergency_contact: "",
    ambulance_contact: "",
    police_contact: "",
    firefighter_contact: "",
  });

  const [editorKey, setEditorKey] = useState(Date.now());

  useEffect(() => {
    if (parameter) {
      console.log("📦 PARAMETER MASUK:", parameter);

      setForm({
        about: parameter.about || "",
        terms: parameter.terms || "",
        report_guidelines: parameter.report_guidelines || "",
        emergency_contact: parameter.emergency_contact || "",
        ambulance_contact: parameter.ambulance_contact || "",
        police_contact: parameter.police_contact || "",
        firefighter_contact: parameter.firefighter_contact || "",
      });

      // 🔁 Force re-render ReactQuill editor
      setEditorKey(Date.now());
    }
  }, [parameter]);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleEditorChange = (name, value) => {
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = () => {
    if (!form.about || !form.terms || !form.report_guidelines) {
      alert("❌ Harap lengkapi kolom utama (About, Terms, Guidelines)");
      return;
    }

    onSave(form);
    onHide();
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered scrollable>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Edit Parameter</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          <Form.Group className="mb-3">
            <Form.Label>About</Form.Label>
            <ReactQuill
              key={`about-${editorKey}`}
              value={form.about}
              onChange={(val) => handleEditorChange("about", val)}
              theme="snow"
              placeholder="Tentang aplikasi..."
              style={{ height: "150px", marginBottom: "40px" }}
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Terms</Form.Label>
            <ReactQuill
              key={`terms-${editorKey}`}
              value={form.terms}
              onChange={(val) => handleEditorChange("terms", val)}
              theme="snow"
              placeholder="Syarat & Ketentuan..."
              style={{ height: "150px", marginBottom: "40px" }}
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Panduan Pelaporan</Form.Label>
            <ReactQuill
              key={`guidelines-${editorKey}`}
              value={form.report_guidelines}
              onChange={(val) => handleEditorChange("report_guidelines", val)}
              theme="snow"
              placeholder="Tata cara pelaporan..."
              style={{ height: "150px", marginBottom: "40px" }}
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
          Simpan Perubahan
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default EditParameterModal;
