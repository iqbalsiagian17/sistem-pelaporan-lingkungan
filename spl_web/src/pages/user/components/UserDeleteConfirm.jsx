import { Modal, Button } from "react-bootstrap";

const UserDeleteConfirm = ({ show, onHide, onConfirm }) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>Hapus Pengguna</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        Apakah Anda yakin ingin menghapus pengguna ini?
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>Batal</Button>
        <Button variant="danger" onClick={onConfirm}>Hapus</Button>
      </Modal.Footer>
    </Modal>
  );
};

export default UserDeleteConfirm;
