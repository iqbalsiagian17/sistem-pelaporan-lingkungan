import { useState } from "react";
import { Modal, Button, Spinner, Table, Badge, Card, ListGroup, Row, Col } from "react-bootstrap";
import { FaFileAlt, FaClock, FaUser, FaEnvelope, FaClipboardList, FaTimesCircle, FaCheckCircle, FaMapMarkerAlt, FaThumbsUp, FaImage, FaHistory, FaMap, FaArrowRight } from "react-icons/fa";
import getFullImageUrl from "../../../utils/getFullImageUrl"; // 🔥 Import helper function
import html2canvas from "html2canvas";
import jsPDF from "jspdf";

const DetailLaporanModal = ({ show, onHide, report }) => {  
  const [loadingImages, setLoadingImages] = useState({});

  const handleImageLoad = (index) => {
    setLoadingImages((prev) => ({ ...prev, [index]: false }));
  };

  const handleImageError = (index) => {
    setLoadingImages((prev) => ({ ...prev, [index]: false }));
  };

  const exportToPDF = async () => {
    const input = document.getElementById('laporanDetailContent');
    if (!input) return;
  
    const canvas = await html2canvas(input, {
      scale: 2,
      useCORS: true,
      allowTaint: true,
    });
  
    const imgData = canvas.toDataURL('image/png');
  
    // ✅ Ubah orientation ke 'landscape'
    const pdf = new jsPDF('vertical', 'mm', 'a4');
  
    const pdfWidth = pdf.internal.pageSize.getWidth();
    const pdfHeight = pdf.internal.pageSize.getHeight();
  
    const imgProps = pdf.getImageProperties(imgData);
    const imgAspectRatio = imgProps.width / imgProps.height;
    const pdfAspectRatio = pdfWidth / pdfHeight;
  
    let imgWidth, imgHeight;
  
    // ✅ Supaya gambar fit dalam PDF landscape
    if (imgAspectRatio > pdfAspectRatio) {
      imgWidth = pdfWidth;
      imgHeight = pdfWidth / imgAspectRatio;
    } else {
      imgHeight = pdfHeight;
      imgWidth = pdfHeight * imgAspectRatio;
    }
  
    const x = (pdfWidth - imgWidth) / 2;
    const y = (pdfHeight - imgHeight) / 2;
  
    pdf.addImage(imgData, 'PNG', x, y, imgWidth, imgHeight);
    pdf.save(`Detail_Laporan_${report?.report_number || "laporan"}.pdf`);
  };
  

  const hasCoordinates = report?.latitude && report?.longitude;
  const googleMapsUrl = hasCoordinates
    ? `https://www.google.com/maps/search/${report.latitude},${report.longitude}`
    : null;

  return (
    <Modal show={show} onHide={onHide} size="xl" centered>
      <Modal.Header closeButton>
        <Modal.Title className="fw-bold">
           Detail Laporan
        </Modal.Title>
      </Modal.Header>
      
      <Modal.Body id="laporanDetailContent" style={{ backgroundColor: "#f8f9fa" }}>
        {report ? (
          <>
            {/* Informasi Laporan */}
            <Card className="mb-4 shadow border-0">
              <Card.Body>
                <h5 className="fw-bold text-primary mb-3">
                  Informasi Laporan
                </h5>
                <ListGroup variant="flush">
                  {[
                    { label: "Judul Laporan", value: report.title, icon: <FaClipboardList /> },
                    { label: "Pelapor", value: report.user?.username || "Tidak tersedia", icon: <FaUser /> },
                    { label: "Email", value: report.user?.email || "Tidak tersedia", icon: <FaEnvelope /> },
                    { label: "Nomor Laporan", value: report.report_number, icon: <FaClipboardList /> },
                    { label: "Dibuat pada", value: new Date(report.createdAt).toLocaleString(), icon: <FaClock /> }
                  ].map((item, idx) => (
                    <ListGroup.Item key={idx} className="d-flex justify-content-between align-items-center">
                      <div className="d-flex align-items-center">
                        {item.icon} <strong className="ms-2">{item.label}</strong>
                      </div>
                      <span className="text-muted">{item.value}</span>
                    </ListGroup.Item>
                  ))}
                </ListGroup>
              </Card.Body>
            </Card>

            {/* Deskripsi */}
            <Card className="mb-4 shadow border-0">
              <Card.Body>
                <h5 className="fw-bold text-primary">
                   Deskripsi Laporan
                </h5>
                <p className="text-muted">{report.description}</p>
              </Card.Body>
            </Card>

            {/* Lokasi */}
            <Card className="mb-4 shadow border-0">
              <Card.Body>
                <Row>
                  <Col xs={12}>
                    <h5 className="fw-bold text-primary">
                       Lokasi
                    </h5>
                    {hasCoordinates ? (
                      <>
                        <p className="mb-1"><strong>Lokasi Kejadian dilihat melalui MAPS</strong></p>
                        <p className="mb-0"><strong>Detail:</strong> {report.location_details || "Tidak ada detail lokasi"}</p>

                        <div className="map-container mt-2">
                          <iframe
                            width="100%"
                            height="250"
                            style={{ border: 0, borderRadius: "10px" }}
                            loading="lazy"
                            allowFullScreen
                            referrerPolicy="no-referrer-when-downgrade"
                            src={`https://www.google.com/maps?q=${report.latitude},${report.longitude}&hl=es;z=14&output=embed`}
                          ></iframe>
                        </div>

                        <a 
                          href={`https://www.google.com/maps/search/?api=1&query=${report.latitude},${report.longitude}`} 
                          target="_blank" 
                          rel="noopener noreferrer" 
                          className="btn btn-success btn-sm mt-2"
                        >
                          <FaMap className="me-2" /> Lihat di Google Maps
                        </a>
                      </>
                    ) : (
                      <>
                        <p className="mb-1"><strong>Desa:</strong> {report.village || "Tidak tersedia"}</p>
                        <p className="mb-0"><strong>Detail:</strong> {report.location_details || "Tidak ada detail lokasi"}</p>
                      </>
                    )}
                  </Col>
                </Row>
              </Card.Body>
            </Card>

            {/* Lampiran */}
            <Card className="mb-4 shadow border-0">
              <Card.Body>
                <h5 className="fw-bold text-primary mb-3">
                  Lampiran
                </h5>
                {report.attachments?.length ? (
                  <Row>
                    {report.attachments.map((attachment, index) => {
                      const imageUrl = getFullImageUrl(attachment.file);
                      return (
                        <Col xs={6} md={4} key={index} className="mb-3">
                          <Card className="shadow-sm border-0">
                            <a href={imageUrl} target="_blank" rel="noopener noreferrer">
                              {loadingImages[index] ? (
                                <div className="d-flex justify-content-center align-items-center" style={{ height: "160px" }}>
                                  <Spinner animation="border" size="sm" />
                                </div>
                              ) : (
                                <img 
                                  src={imageUrl} 
                                  alt={`Lampiran ${index + 1}`} 
                                  className="card-img-top rounded" 
                                  style={{ height: "180px", objectFit: "cover" }} 
                                  onLoad={() => handleImageLoad(index)}
                                  onError={(e) => {
                                    e.target.src = "/assets/img/default-image.png";
                                    handleImageError(index);
                                  }}
                                />
                              )}
                            </a>
                          </Card>
                        </Col>
                      );
                    })}
                  </Row>
                ) : <p className="text-muted">Tidak ada lampiran</p>}
              </Card.Body>
            </Card>

            {/* Riwayat Status */}
            <Card className="shadow border-0">
              <Card.Body>
                <h5 className="fw-bold text-primary mb-3">
                  Riwayat Perubahan Status
                </h5>
                {report.statusHistory?.length ? (
                  <div className="d-flex flex-column gap-3 w-100">
                    {report.statusHistory.map((history, index) => (
                      <div
                        key={index}
                        className="p-3 rounded shadow-sm w-100"
                        style={{
                          background: "#ffffff",
                          borderLeft: "4px solid #007bff"
                        }}
                      >
                        <div className="d-flex justify-content-between align-items-center">
                          <span className="fw-bold text-dark">{history.changed_by?.username || "Admin"}</span>
                          <span className="text-muted small">{new Date(history.createdAt).toLocaleString()}</span>
                        </div>

                        <div className="d-flex align-items-center mt-2">
                          <span className="badge bg-secondary me-2">{history.previous_status.toUpperCase()}</span>
                          <FaArrowRight className="text-muted" />
                          <span className="badge bg-primary ms-2">{history.new_status.toUpperCase()}</span>
                        </div>

                        {history.message && (
                          <div className="mt-2 p-2 rounded w-100" style={{ background: "#f8f9fa" }}>
                            <p className="mb-0 text-dark">{history.message}</p>
                          </div>
                        )}

                        {history.new_status === "completed" && report.evidences?.length > 0 && (
                          <div className="mt-3">
                            <p className="fw-bold mb-2">📷 Bukti Tindakan:</p>
                            <Row>
                              {report.evidences.map((evidence, i) => {
                                const imageUrl = getFullImageUrl(evidence.file);
                                return (
                                  <Col xs={6} md={4} key={i} className="mb-2">
                                    <Card className="shadow-sm border-0">
                                      <a href={imageUrl} target="_blank" rel="noopener noreferrer">
                                        <img
                                          src={imageUrl}
                                          alt={`Evidence ${i + 1}`}
                                          className="card-img-top rounded"
                                          style={{ height: "180px", objectFit: "cover" }}
                                          onError={(e) => {
                                            e.target.src = "/assets/img/default-image.png";
                                          }}
                                        />
                                      </a>
                                    </Card>
                                  </Col>
                                );
                              })}
                            </Row>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                ) : <p className="text-muted">Tidak ada riwayat perubahan status</p>}
              </Card.Body>
            </Card>
          </>
        ) : <p className="text-center text-muted">Memuat detail...</p>}
      </Modal.Body>

      <Modal.Footer className="bg-white shadow-sm">
        <Button variant="secondary" onClick={exportToPDF}>
          <FaFileAlt className="me-2" /> Export PDF
        </Button>
        <Button variant="danger" onClick={onHide}>
          <FaTimesCircle className="me-2" /> Tutup
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default DetailLaporanModal;
