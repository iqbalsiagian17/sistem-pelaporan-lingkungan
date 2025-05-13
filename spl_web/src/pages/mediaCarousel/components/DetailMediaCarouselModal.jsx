import { Modal, Button } from "react-bootstrap";

const MediaDetailCarouselModal = ({ show, onHide, mediaCarousel }) => {
  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">Detail Media Carousel</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {mediaCarousel ? (
          <>
            <h4 className="fw-bold mb-3">{mediaCarousel.title}</h4>

            <p className="mb-4 text-muted">
              {mediaCarousel.description ? (
                mediaCarousel.description
              ) : (
                <em>(Tidak ada deskripsi)</em>
              )}
            </p>

            {mediaCarousel.image && (
              <div className="text-center">
                <img
                  src={`http://69.62.82.58:3000/${mediaCarousel.image}`}
                  alt="Gambar Media Carousel"
                  className="img-fluid rounded shadow-sm border"
                  style={{ maxHeight: "300px", objectFit: "contain" }}
                />
              </div>
            )}
          </>
        ) : (
          <p className="text-muted">Memuat detail media carousel...</p>
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

export default MediaDetailCarouselModal;
