import { useState, useEffect } from "react";
import { Modal, Button, Form, Spinner } from "react-bootstrap";
import statusData from "../../../data/statusData.json";

const StatusLaporanModal = ({
  show,
  onHide,
  selectedReport,
  newStatus,
  setNewStatus,
  message,
  setMessage,
  handleChangeStatus,
}) => {
  const allowedTransitions = statusData.allowedTransitions;
  const statusTranslations = statusData.statusTranslations;
  const nextStatuses = selectedReport?.status
    ? allowedTransitions[selectedReport.status] || []
    : [];

  const [uploadedEvidences, setUploadedEvidences] = useState([]);
  const [isUpdating, setIsUpdating] = useState(false);

  useEffect(() => {
    setUploadedEvidences([]);
  }, [newStatus]);

  useEffect(() => {
    if (!show) {
      setNewStatus("");
      setMessage("");
      setUploadedEvidences([]);
      setIsUpdating(false);
    }
  }, [show, setNewStatus, setMessage]);

  const handleStatusChange = (e) => {
    const status = e.target.value;
    setNewStatus(status);
    setMessage(`Status laporan telah berubah menjadi: ${statusTranslations[status]}.`);
  };

  const handleFileChange = (e) => {
    const files = Array.from(e.target.files);
    setUploadedEvidences(files.slice(0, 5));
  };

  const onSubmit = async () => {
    setIsUpdating(true);
    await handleChangeStatus(uploadedEvidences);
    setIsUpdating(false);
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <div style={{ position: "relative" }}>
        {isUpdating && (
          <div
            style={{
              position: "absolute",
              top: 0,
              left: 0,
              width: "100%",
              height: "100%",
              zIndex: 1051,
              backgroundColor: "rgba(255,255,255,0.7)",
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              borderRadius: "0.3rem",
            }}
          >
            <Spinner animation="border" variant="primary" />
          </div>
        )}

        <Modal.Header closeButton>
          <Modal.Title>Perbarui Status Laporan</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {selectedReport ? (
            <Form>
              {nextStatuses.length > 0 ? (
                <>
                  <Form.Group className="mb-3">
                    <Form.Label><strong>Status Baru</strong></Form.Label>
                    <Form.Select value={newStatus || ""} onChange={handleStatusChange}>
                      <option value="" disabled>Pilih Status Baru</option>
                      {nextStatuses.map((status, idx) => (
                        <option key={idx} value={status}>
                          {statusTranslations[status]}
                        </option>
                      ))}
                    </Form.Select>
                  </Form.Group>

                  <Form.Group className="mb-3">
                    <Form.Label><strong>Pesan Perubahan</strong></Form.Label>
                    <Form.Control
                      as="textarea"
                      rows={2}
                      value={message}
                      onChange={(e) => setMessage(e.target.value)}
                      placeholder="Tambahkan catatan perubahan status..."
                    />
                  </Form.Group>

                  {newStatus === "completed" && (
                    <Form.Group className="mb-3">
                      <Form.Label><strong>Upload Bukti (Opsional)</strong></Form.Label>
                      <Form.Control
                        type="file"
                        multiple
                        accept="image/*"
                        onChange={handleFileChange}
                      />
                      <Form.Text className="text-muted">
                        Anda dapat mengunggah <strong>maksimal 5 gambar</strong> sebagai bukti.
                      </Form.Text>

                      {uploadedEvidences.length > 0 && (
                        <div className="mt-2 d-flex flex-wrap gap-2">
                          {uploadedEvidences.map((file, idx) => (
                            <img
                              key={idx}
                              src={URL.createObjectURL(file)}
                              alt={`preview-${idx}`}
                              style={{
                                width: "70px",
                                height: "70px",
                                objectFit: "cover",
                                borderRadius: "5px",
                                border: "1px solid #dee2e6",
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </Form.Group>
                  )}
                </>
              ) : (
                <p className="text-muted text-center">Status tidak dapat diubah lagi.</p>
              )}
            </Form>
          ) : (
            <p>Memuat data laporan...</p>
          )}
        </Modal.Body>
        <Modal.Footer>
          <Button
            variant="secondary"
            onClick={onHide}
            disabled={isUpdating || nextStatuses.length === 0}
          >
            Batal
          </Button>
          <Button
            variant="primary"
            onClick={onSubmit}
            disabled={
              isUpdating ||
              !newStatus ||
              !message ||
              (newStatus === "completed" && uploadedEvidences.length > 5)
            }
          >
            Simpan Perubahan
          </Button>
        </Modal.Footer>
      </div>
    </Modal>
  );
};

export default StatusLaporanModal;
