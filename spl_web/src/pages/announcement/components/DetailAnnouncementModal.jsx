import { Modal, Button, Badge } from "react-bootstrap";

const API_BASE_URL = "http://localhost:3000"; 

const AnnouncementDetailModal = ({ show, onHide, announcement }) => {
  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">📢 Detail Pengumuman</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        {announcement ? (
          <>
            {/* Judul */}
            <h4 className="fw-bold mb-3 text-primary">{announcement.title}</h4>

            {/* Tanggal */}
            <p className="text-muted mb-3">
              🗓️ Dibuat pada:{" "}
              <Badge bg="light" text="dark">
                {new Date(announcement.createdAt).toLocaleString("id-ID", {
                  dateStyle: "medium",
                  timeStyle: "short",
                })}
              </Badge>
            </p>

            {/* Deskripsi (HTML) */}
            <div
              className="mb-4"
              dangerouslySetInnerHTML={{ __html: announcement.description }}
              style={{ border: "1px solid #ddd", borderRadius: "5px", padding: "15px", background: "#fafafa" }}
            />

            {/* File */}
            {announcement.file && (
              <div>
                <p className="mb-1 fw-bold">📎 Lampiran:</p>
                <a
                  href={`${API_BASE_URL}/${announcement.file}`}
                  className="btn btn-outline-primary btn-sm"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Lihat File
                </a>
              </div>
            )}
          </>
        ) : (
          <p className="text-muted">Memuat detail pengumuman...</p>
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

export default AnnouncementDetailModal;
