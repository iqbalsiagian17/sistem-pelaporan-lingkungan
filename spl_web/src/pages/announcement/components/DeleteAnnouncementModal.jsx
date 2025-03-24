import { Modal, Button } from "react-bootstrap";

const AnnouncementDeleteConfirm = ({ show, onHide, onConfirm }) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title className="text-danger">🗑️ Konfirmasi Hapus</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        Apakah Anda yakin ingin menghapus pengumuman ini?
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Batal
        </Button>
        <Button variant="danger" onClick={onConfirm}>
          Hapus
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default AnnouncementDeleteConfirm;
