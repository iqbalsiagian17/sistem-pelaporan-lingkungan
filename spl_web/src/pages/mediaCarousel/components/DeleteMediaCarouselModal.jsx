// src/pages/carousel/components/CarouselDeleteModal.jsx
import { Modal, Button } from "react-bootstrap";

const MediaCarouselDeleteModal = ({ show, onHide, onConfirm }) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title className="text-danger fw-bold">
          🗑️ Konfirmasi Hapus Carousel
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>Apakah Anda yakin ingin menghapus carousel ini? Tindakan ini tidak dapat dibatalkan.</p>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Batal
        </Button>
        <Button variant="danger" onClick={onConfirm}>
          Hapus Sekarang
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default MediaCarouselDeleteModal;
