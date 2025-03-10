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


    // ✅ Isi otomatis pesan perubahan status (bisa diedit)
    const handleStatusChange = (e) => {
        const status = e.target.value;
        setNewStatus(status);
        setMessage(`Status laporan telah berubah menjadi: ${statusTranslations[status]}.`);
    };

    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>Perbarui Status Laporan</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                {selectedReport ? (
                    <Form>
                        {/* ✅ Dropdown Status Baru (Hanya tampil jika ada opsi) */}
                        {nextStatuses.length > 0 ? (
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
                        ) : (
                            <p className="text-muted text-center">🚫 Status tidak dapat diubah lagi.</p>
                        )}

                        {/* ✅ Input Pesan Perubahan */}
                        {nextStatuses.length > 0 && (
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
                        )}
                    </Form>
                ) : (
                    <p>Memuat data laporan...</p> // ✅ Tampilkan pesan loading jika `selectedReport` masih null
                )}
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide} disabled={nextStatuses.length === 0}>
                    Batal
                </Button>
                <Button 
                    variant="primary" 
                    onClick={handleChangeStatus} 
                    disabled={!newStatus || !message} 
                >
                    Simpan Perubahan
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default StatusLaporanModal;
