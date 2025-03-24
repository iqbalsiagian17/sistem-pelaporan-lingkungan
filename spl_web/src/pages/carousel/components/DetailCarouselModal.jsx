// src/pages/carousel/components/DetailCarouselModal.jsx
import { Modal, Button } from "react-bootstrap";

const DetailCarouselModal = ({ show, onHide, carousel }) => {
  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">🖼️ Detail Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {carousel ? (
          <>
            <h4 className="fw-bold mb-3">{carousel.title}</h4>

            <div
              className="mb-4"
              dangerouslySetInnerHTML={{ __html: carousel.description || "<em>(Tidak ada deskripsi)</em>" }}
            />

            {carousel.image && (
              <div className="text-center">
                <img
                  src={`http://localhost:3000/${carousel.image}`}
                  alt="Gambar Carousel"
                  className="img-fluid rounded shadow-sm"
                  style={{ maxHeight: "300px", objectFit: "contain" }}
                />
              </div>
            )}
          </>
        ) : (
          <p className="text-muted">Memuat detail carousel...</p>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Tutup
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default DetailCarouselModal;
