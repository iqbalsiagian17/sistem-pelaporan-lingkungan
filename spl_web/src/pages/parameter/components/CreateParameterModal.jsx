import { useState } from "react";
import { Modal, Button, Form, Row, Col } from "react-bootstrap";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import MapBoundaryEditor from "../../village/components/MapBoundaryEditor";

const CreateParameterModal = ({ show, onHide, onCreate }) => {
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

  const handleQuillChange = (field, value) => {
    setForm((prev) => ({ ...prev, [field]: value }));
    if (!isQuillEmpty(value)) {
      setErrors((prev) => ({ ...prev, [field]: null }));
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm({ ...form, [name]: value });
    if (value.trim()) {
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
      if (!form[field].trim()) {
        newErrors[field] = "Kolom ini wajib diisi.";
      }
    });

    // Validasi polygon
    if (!form.location_validation_area) {
      newErrors.location_validation_area = "Wilayah validasi lokasi wajib ditentukan.";
    } else {
      const area = form.location_validation_area;
      if (
        !area.type ||
        area.type !== "Polygon" ||
        !Array.isArray(area.coordinates)
      ) {
        newErrors.location_validation_area = "Batas wilayah tidak valid (GeoJSON Polygon diperlukan).";
      }
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const formData = new FormData();
    Object.entries(form).forEach(([key, value]) => {
      if (key === "location_validation_area") {
        formData.append(key, JSON.stringify(value)); // ✅ kirim sebagai string JSON
      } else {
        formData.append(key, value);
      }
    });
    if (video) {
      formData.append("landing_video", video);
    }

    onCreate(formData);
    onHide();
    resetForm();
  };

  const resetForm = () => {
    setForm({
      about: "",
      terms: "",
      report_guidelines: "",
      emergency_contact: "",
      ambulance_contact: "",
      police_contact: "",
      firefighter_contact: "",
      location_validation_area: null,
    });
    setVideo(null);
    setErrors({});
  };

  return (
    <Modal show={show} onHide={onHide} size="xl" centered scrollable>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Tambah Parameter</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <Form>
          {/* About */}
          <Form.Group className="mb-4">
            <Form.Label>Tentang Aplikasi</Form.Label>
            <div className={`border rounded ${errors.about ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                value={form.about}
                onChange={(val) => handleQuillChange("about", val)}
                theme="snow"
                placeholder="Tentang aplikasi..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.about && <div className="text-danger mt-1">{errors.about}</div>}
          </Form.Group>

          {/* Terms */}
          <Form.Group className="mb-4">
            <Form.Label>Syarat & Ketentuan</Form.Label>
            <div className={`border rounded ${errors.terms ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                value={form.terms}
                onChange={(val) => handleQuillChange("terms", val)}
                theme="snow"
                placeholder="Syarat dan ketentuan..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.terms && <div className="text-danger mt-1">{errors.terms}</div>}
          </Form.Group>

          {/* Guidelines */}
          <Form.Group className="mb-4">
            <Form.Label>Panduan Pelaporan</Form.Label>
            <div className={`border rounded ${errors.report_guidelines ? "border-danger" : ""}`} style={{ maxHeight: 300, overflowY: "auto" }}>
              <ReactQuill
                value={form.report_guidelines}
                onChange={(val) => handleQuillChange("report_guidelines", val)}
                theme="snow"
                placeholder="Tata cara pelaporan..."
                style={{ minHeight: 150 }}
              />
            </div>
            {errors.report_guidelines && <div className="text-danger mt-1">{errors.report_guidelines}</div>}
          </Form.Group>

          {/* Emergency Contacts */}
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
                  placeholder="08xxxx / 112"
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
                  placeholder="08xxxx / 119"
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
                  placeholder="110"
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
                  placeholder="113"
                />
                <Form.Control.Feedback type="invalid">{errors.firefighter_contact}</Form.Control.Feedback>
              </Form.Group>
            </Col>
          </Row>

          {/* Polygon Editor */}
          <Form.Group className="mb-4">
            <Form.Label>Wilayah Validasi Lokasi (Polygon)</Form.Label>
            <MapBoundaryEditor
              initialPolygon={form.location_validation_area}
              onPolygonCreated={(geojson) =>
                setForm((prev) => ({ ...prev, location_validation_area: geojson }))
              }
            />
            {errors.location_validation_area && (
              <div className="text-danger mt-1">{errors.location_validation_area}</div>
            )}
          </Form.Group>

          {/* Video Landing */}
          <Form.Group className="mb-3">
            <Form.Label>Video Landing (Opsional)</Form.Label>
            <Form.Control
              type="file"
              accept="video/*"
              onChange={(e) => setVideo(e.target.files[0])}
            />
            {video && (
              <div className="mt-2">
                <video
                  src={URL.createObjectURL(video)}
                  controls
                  style={{ width: "100%", maxHeight: 240, borderRadius: 8 }}
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
          Simpan
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default CreateParameterModal;
