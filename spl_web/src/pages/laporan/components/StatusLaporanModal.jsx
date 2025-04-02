import { useState } from "react";   
import { Modal, Button, Form } from "react-bootstrap";
import statusData from "../../../data/statusData.json"; // ✅ Import data status dari JSON


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

    // ✅ Ambil terjemahan status dari JSON
    const statusTranslations = statusData.statusTranslations;

    // ✅ Ambil status yang boleh dipilih
    const nextStatuses = selectedReport?.status ? allowedTransitions[selectedReport.status] || [] : [];

    const [uploadedEvidences, setUploadedEvidences] = useState([]); // ✅ Gunakan state

    const [isUpdating, setIsUpdating] = useState(false);




    // ✅ Isi otomatis pesan perubahan status (bisa diedit)
    const handleStatusChange = (e) => {
        const status = e.target.value;
        setNewStatus(status);
        setMessage(`Status laporan telah berubah menjadi: ${statusTranslations[status]}.`);
    };

    const handleFileChange = (e) => {
        setUploadedEvidences(Array.from(e.target.files)); // ⬅️ pastikan array of File
      };

      const onSubmit = async () => {
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
    
                    {/* ✅ Tampilkan input file hanya jika statusnya completed */}
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
                          Anda dapat mengunggah lebih dari satu gambar sebagai bukti.
                        </Form.Text>
                      </Form.Group>
                    )}
                  </>
                ) : (
                  <p className="text-muted text-center">🚫 Status tidak dapat diubah lagi.</p>
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
              disabled={!newStatus || !message}
            >
              {isUpdating ? "Menyimpan..." : "Simpan Perubahan"}
            </Button>
          </Modal.Footer>
        </Modal>
      );
    };
    
    export default StatusLaporanModal;