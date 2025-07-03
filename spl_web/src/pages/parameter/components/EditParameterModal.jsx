import { useState, useEffect } from "react";
import { Modal, Button, Form, Row, Col } from "react-bootstrap";
import MapBoundaryEditor from "../../village/components/MapBoundaryEditor";
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
    location_validation_area: null,
  });

  const [video, setVideo] = useState(null);
  const [errors, setErrors] = useState({});
  const [editorKey, setEditorKey] = useState(Date.now());

  useEffect(() => {
    if (parameter) {
      setForm({
        about: parameter.about || "",
        terms: parameter.terms || "",
        report_guidelines: parameter.report_guidelines || "",
        emergency_contact: parameter.emergency_contact || "",
        ambulance_contact: parameter.ambulance_contact || "",
        police_contact: parameter.police_contact || "",
        firefighter_contact: parameter.firefighter_contact || "",
        location_validation_area: parameter.location_validation_area || null,
      });
      setVideo(null);
      setErrors({});
      setEditorKey(Date.now());
    }
  }, [parameter]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
    if (value.trim() !== "") {
      setErrors((prev) => ({ ...prev, [name]: null }));
    }
  };

  const handleEditorChange = (name, value) => {
    setForm((prev) => ({ ...prev, [name]: value }));
    if (!isQuillEmpty(value)) {
      setErrors((prev) => ({ ...prev, [name]: null }));
    }
  };

  const isQuillEmpty = (html) => {
    const plain = html.replace(/<(.|\n)*?>/g, "").trim();
    return plain === "";
  };

  const handleSubmit = () => {
    const newErrors = {};

    if (isQuillEmpty(form.about)) newErrors.about = "Kolom ini wajib diisi.";
    if (isQuillEmpty(form.terms)) newErrors.terms = "Kolom ini wajib diisi.";
    if (isQuillEmpty(form.report_guidelines)) newErrors.report_guidelines = "Kolom ini wajib diisi.";

    ["emergency_contact", "ambulance_contact", "police_contact", "firefighter_contact"].forEach((field) => {
      const value = form[field].trim();
      if (!value) {
        newErrors[field] = "Kolom ini wajib diisi.";
      } else if (!/^\d+$/.test(value)) {
        newErrors[field] = "Hanya boleh diisi dengan angka.";
      }
    });

    const area = form.location_validation_area;
    if (area && (area.type !== "Polygon" || !Array.isArray(area.coordinates))) {
      newErrors.location_validation_area = "Batas wilayah tidak valid (GeoJSON Polygon diperlukan)";
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const formData = new FormData();
    Object.entries(form).forEach(([key, value]) => {
      formData.append(key, typeof value === "object" ? JSON.stringify(value) : value);
    });

    if (video) {
      formData.append("landing_video", video);
    }

    formData.append("id", parameter.id);
    onSave(formData);
    onHide();
  };

  return (
    <Modal show={show} onHide={onHide} size="xl" centered scrollable>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Edit Parameter</Modal.Title>
      </Modal.Header>

      <Modal.Body style={{ maxHeight: "75vh", overflowY: "auto" }}>
        <Form>
          {/* About */}
          <Form.Group className="mb-3">
            <Form.Label>About</Form.Label>
            <div className={`border rounded ${errors.about ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                key={`about-${editorKey}`}
                value={form.about}
                onChange={(val) => handleEditorChange("about", val)}
                theme="snow"
                placeholder="Tentang aplikasi..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.about && <div className="text-danger mt-1">{errors.about}</div>}
          </Form.Group>

          {/* Terms */}
          <Form.Group className="mb-3">
            <Form.Label>Terms</Form.Label>
            <div className={`border rounded ${errors.terms ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                key={`terms-${editorKey}`}
                value={form.terms}
                onChange={(val) => handleEditorChange("terms", val)}
                theme="snow"
                placeholder="Syarat & Ketentuan..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.terms && <div className="text-danger mt-1">{errors.terms}</div>}
          </Form.Group>

          {/* Guidelines */}
          <Form.Group className="mb-3">
            <Form.Label>Panduan Pelaporan</Form.Label>
            <div className={`border rounded ${errors.report_guidelines ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                key={`guidelines-${editorKey}`}
                value={form.report_guidelines}
                onChange={(val) => handleEditorChange("report_guidelines", val)}
                theme="snow"
                placeholder="Tata cara pelaporan..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.report_guidelines && <div className="text-danger mt-1">{errors.report_guidelines}</div>}
          </Form.Group>

          {/* Kontak */}
          <Row>
            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Kontak Darurat</Form.Label>
                <Form.Control
                  type="text"
                  name="emergency_contact"
                  value={form.emergency_contact}
                  onChange={handleChange}
                  isInvalid={!!errors.emergency_contact}
                  placeholder="08xxxx / 112 / lainnya"
                />
                <Form.Control.Feedback type="invalid">{errors.emergency_contact}</Form.Control.Feedback>
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
                  isInvalid={!!errors.ambulance_contact}
                  placeholder="08xxxx / 119 / lainnya"
                />
                <Form.Control.Feedback type="invalid">{errors.ambulance_contact}</Form.Control.Feedback>
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
                  isInvalid={!!errors.police_contact}
                  placeholder="110 / kontak polisi"
                />
                <Form.Control.Feedback type="invalid">{errors.police_contact}</Form.Control.Feedback>
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
                  isInvalid={!!errors.firefighter_contact}
                  placeholder="113 / kontak damkar"
                />
                <Form.Control.Feedback type="invalid">{errors.firefighter_contact}</Form.Control.Feedback>
              </Form.Group>
            </Col>
          </Row>

          {/* Lokasi Validasi */}
          <Form.Group className="mb-3">
            <Form.Label>Wilayah Validasi Lokasi</Form.Label>
            <MapBoundaryEditor
              initialPolygon={form.location_validation_area}
              onPolygonCreated={(geojson) =>
                setForm((prev) => ({ ...prev, location_validation_area: geojson }))
              }
            />
            <Form.Text muted>
              Wilayah ini digunakan untuk memvalidasi lokasi laporan pengguna.
            </Form.Text>
            {errors.location_validation_area && (
              <div className="text-danger mt-1">{errors.location_validation_area}</div>
            )}
          </Form.Group>

          {/* Video */}
          <Form.Group className="mb-3">
            <Form.Label>Video Landing (Opsional)</Form.Label>
            <Form.Control
              type="file"
              accept="video/*"
              onChange={(e) => setVideo(e.target.files[0])}
            />
            {!video && parameter?.landing_video && (
              <div className="mt-2">
                <video
                  src={`http://localhost:3000${parameter.landing_video}`}
                  controls
                  style={{ width: "100%", maxHeight: 240, borderRadius: "8px" }}
                />
              </div>
            )}
          </Form.Group>
        </Form>
      </Modal.Body>

      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="primary" onClick={handleSubmit}>Simpan Perubahan</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default EditParameterModal;
