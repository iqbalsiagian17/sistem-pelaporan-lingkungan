import { Modal, Button, Row, Col } from "react-bootstrap";
import { MapContainer, TileLayer, Polygon } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

const DetailParameterModal = ({ show, onHide, parameter }) => {
  if (!parameter) return null;

  const boundary = parameter.location_validation_area;
  let polygonPoints = [];

  if (
    boundary?.type === "Polygon" &&
    Array.isArray(boundary.coordinates) &&
    boundary.coordinates.length > 0
  ) {
    // Konversi ke [lat, lng]
    polygonPoints = boundary.coordinates[0].map(([lng, lat]) => [lat, lng]);
  }

  const center = polygonPoints.length > 0
    ? getPolygonCenter(polygonPoints)
    : [2.35, 99.06]; // fallback center Balige

  return (
    <Modal show={show} onHide={onHide} size="lg" centered scrollable>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Detail Parameter</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Row className="mb-4">
          <Col>
            <h6 className="fw-bold">Tentang Aplikasi (About)</h6>
            <div
              className="text-muted"
              dangerouslySetInnerHTML={{
                __html: parameter.about || "<p>-</p>",
              }}
            />
          </Col>
        </Row>

        <Row className="mb-4">
          <Col>
            <h6 className="fw-bold">Syarat & Ketentuan (Terms)</h6>
            <div
              className="text-muted"
              dangerouslySetInnerHTML={{
                __html: parameter.terms || "<p>-</p>",
              }}
            />
          </Col>
        </Row>

        <Row className="mb-4">
          <Col>
            <h6 className="fw-bold">Panduan Pelaporan</h6>
            <div
              className="text-muted"
              dangerouslySetInnerHTML={{
                __html: parameter.report_guidelines || "<p>-</p>",
              }}
            />
          </Col>
        </Row>

        <Row className="mb-4">
          <Col>
            <h6 className="fw-bold">Wilayah Validasi Lokasi</h6>
            {polygonPoints.length > 2 ? (
              <div style={{ height: 250, borderRadius: 8, overflow: "hidden" }}>
                <MapContainer center={center} zoom={13} style={{ height: "100%", width: "100%" }}>
                  <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
                  <Polygon positions={polygonPoints} pathOptions={{ color: "green", fillOpacity: 0.3 }} />
                </MapContainer>
                <p className="text-muted mt-2" style={{ fontSize: 13 }}>
                  Wilayah di atas digunakan untuk memvalidasi apakah lokasi laporan berada dalam cakupan yang diizinkan.
                </p>
              </div>
            ) : (
              <p className="text-muted">Wilayah belum ditentukan.</p>
            )}
          </Col>
        </Row>

        <Row className="mb-4">
          <Col>
            <h6 className="fw-bold">Video Landing</h6>
            {parameter.landing_video ? (
              <div className="ratio ratio-16x9">
                <video
                  src={`http://localhost:3000${parameter.landing_video}`}
                  controls
                  style={{ borderRadius: 8 }}
                />
              </div>
            ) : (
              <p className="text-muted">Belum ada video.</p>
            )}
          </Col>
        </Row>

        <Row className="mb-3">
          <Col md={6}>
            <h6 className="fw-bold">Kontak Darurat</h6>
            <p className="text-muted">{parameter.emergency_contact || "-"}</p>
          </Col>
          <Col md={6}>
            <h6 className="fw-bold">Ambulans</h6>
            <p className="text-muted">{parameter.ambulance_contact || "-"}</p>
          </Col>
        </Row>

        <Row className="mb-3">
          <Col md={6}>
            <h6 className="fw-bold">Polisi</h6>
            <p className="text-muted">{parameter.police_contact || "-"}</p>
          </Col>
          <Col md={6}>
            <h6 className="fw-bold">Pemadam Kebakaran</h6>
            <p className="text-muted">{parameter.firefighter_contact || "-"}</p>
          </Col>
        </Row>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Tutup
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

// ✅ Fungsi hitung titik tengah polygon
function getPolygonCenter(points) {
  const latSum = points.reduce((sum, p) => sum + p[0], 0);
  const lngSum = points.reduce((sum, p) => sum + p[1], 0);
  return [latSum / points.length, lngSum / points.length];
}

export default DetailParameterModal;
