import { useState, useEffect } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import statusData from "../../../data/statusData.json";

const StatusLaporanModal = ({
  show,
  onHide,
  selectedReport,
  newStatus,
  setNewStatus,
  message,
  setMessage,
  handleChangeStatus
}) => {
  const allowedTransitions = statusData.allowedTransitions;
  const statusTranslations = statusData.statusTranslations;
  const nextStatuses = selectedReport?.status ? allowedTransitions[selectedReport.status] || [] : [];

  const [uploadedEvidences, setUploadedEvidences] = useState([]);
  const [isUpdating, setIsUpdating] = useState(false);

  useEffect(() => {
    // Reset uploaded files jika status berubah
    setUploadedEvidences([]);
  }, [newStatus]);

  const handleStatusChange = (e) => {
    const status = e.target.value;
    setNewStatus(status);
    setMessage(`Status laporan telah berubah menjadi: ${statusTranslations[status]}.`);
  };

  const handleFileChange = (e) => {
    const files = Array.from(e.target.files);
    if (files.length > 5) {
      alert("Maksimal 5 gambar yang dapat diunggah.");
    }
    setUploadedEvidences(files);
  };

  const onSubmit = async () => {
    if (newStatus === "completed" && uploadedEvidences.length > 5) {
      alert("Anda hanya dapat mengunggah maksimal 5 gambar.");
      return;
    }

    setIsUpdating(true);
    await handleChangeStatus(uploadedEvidences);
    setIsUpdating(false);
  };

  return (
    <Modal show={show} onHide={onHide} centered>
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
                    {uploadedEvidences.length > 5 && (
                      <div className="text-danger mt-1">Maksimal hanya 5 gambar yang diperbolehkan.</div>
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
        <Button variant="secondary" onClick={onHide} disabled={nextStatuses.length === 0}>
          Batal
        </Button>
        <Button
          variant="primary"
          onClick={onSubmit}
          disabled={!newStatus || !message || (newStatus === "completed" && uploadedEvidences.length > 5)}
        >
          {isUpdating ? "Menyimpan..." : "Simpan Perubahan"}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default StatusLaporanModal;
