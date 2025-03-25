import { Modal, Button, Row, Col } from "react-bootstrap";

const DetailParameterModal = ({ show, onHide, parameter }) => {
  if (!parameter) return null;

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

export default DetailParameterModal;
