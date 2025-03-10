import { useState, useEffect, useRef } from "react";
import { Dropdown, Table, Badge, Card, Form, Row, Col, InputGroup, Button } from "react-bootstrap";
import statusData from "../../../data/statusData.json"; // ✅ Import data status dari JSON

const LaporanTable = ({ reports, handleOpenDetailModal, handleOpenStatusModal, handleDeleteReport }) => {
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedStatus, setSelectedStatus] = useState("");
    const [showStatusDropdown, setShowStatusDropdown] = useState(false);
    const [dropdownPosition, setDropdownPosition] = useState({ top: 0, left: 0 });

    const dropdownRef = useRef(null);
    const statusHeaderRef = useRef(null);

    // **🔍 Filter berdasarkan Status dan Nomor Laporan**
    const filteredReports = reports
        .slice()
        .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)) // ✅ Urutkan dari terbaru ke terlama
        .filter(report => {
            const matchSearch = report.report_number.toLowerCase().includes(searchQuery.toLowerCase());
            const matchStatus = selectedStatus ? report.status === selectedStatus : true;
            return matchSearch && matchStatus;
        });

    // **🎛️ Ambil data status dari JSON**
    const statusMappings = statusData.statusMappings;

    // **🖱️ Menutup dropdown saat klik di luar area**
    useEffect(() => {
        const handleClickOutside = (event) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setShowStatusDropdown(false);
            }
        };
        document.addEventListener("mousedown", handleClickOutside);
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);

    // **📌 Menentukan posisi dropdown secara dinamis**
    const handleDropdownToggle = () => {
        if (statusHeaderRef.current) {
            const rect = statusHeaderRef.current.getBoundingClientRect();
            setDropdownPosition({
                top: rect.bottom + window.scrollY,
                left: rect.left + window.scrollX
            });
        }
        setShowStatusDropdown((prev) => !prev);
    };

    return (
        <Card className="shadow-sm border-0">
            <Card.Header className="fw-bold text-primary bg-light">
                <Row className="align-items-center g-2">
                    {/* 📌 Judul Laporan (Tetap di kiri di mode desktop, tengah di mobile) */}
                    <Col xs={12} md={6} className="text-center text-md-start">
                        <h5 className="mb-0">📋 Daftar Laporan</h5>
                    </Col>

                    {/* 🔍 Input Pencarian (Turun ke bawah di mode mobile) */}
                    <Col xs={12} md={6}>
                        <InputGroup>
                            <Form.Control
                                type="text"
                                placeholder="Masukkan Nomor Laporan..."
                                value={searchQuery}
                                className="border-0 shadow-sm"
                                onChange={(e) => setSearchQuery(e.target.value)}
                            />
                            <Button 
                                variant="outline-secondary" 
                                className="border-0 shadow-sm" 
                                onClick={() => setSearchQuery("")}
                            >
                                ❌
                            </Button>
                        </InputGroup>
                    </Col>
                </Row>
            </Card.Header>
            {/* 🔹 Tabel Laporan */}
            <div className="table-responsive">
                <Table hover className="align-middle">
                    <thead className="bg-light">
                        <tr>
                            <th>No</th>
                            <th>Pelapor</th>
                            <th>Judul</th>
                            <th>Nomor</th>
                            <th>Diajukan</th>
                            {/* 🔥 Dropdown untuk filter status */}
                            <th ref={statusHeaderRef} className="position-relative">
                                <Button
                                    variant="light"
                                    size="sm"
                                    className="border-0"
                                    onClick={handleDropdownToggle}
                                >
                                    Status <i className="bx bx-filter-alt"></i>
                                </Button>
                            </th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredReports.length > 0 ? (
                            filteredReports.map((report, index) => (
                                <tr key={report.id}>
                                    <td>{index + 1}</td>
                                    <td>{report.user?.username || "-"}</td>
                                    <td><strong>{report.title || "-"}</strong></td>
                                    <td>{report.report_number || "-"}</td>
                                    <td>{new Date(report.createdAt).toLocaleDateString("id-ID")}</td>
                                    <td>
                                        <Badge bg={statusMappings[report.status]?.color || "secondary"} className="text-uppercase">
                                            {statusMappings[report.status]?.label || "Tidak Diketahui"}
                                        </Badge>
                                    </td>
                                    <td>
                                    <Dropdown align="end">
                                        <Dropdown.Toggle as="span" style={{ cursor: "pointer", fontSize: "18px" }}>
                                            <i className="bx bx-dots-vertical-rounded"></i>
                                        </Dropdown.Toggle>
                                        <Dropdown.Menu align="end">
                                            <Dropdown.Item onClick={() => handleOpenDetailModal(report.id)}>
                                                Lihat Laporan
                                            </Dropdown.Item>
                                            <Dropdown.Item onClick={() => handleOpenStatusModal(report)}>
                                                Tindak Lanjuti
                                            </Dropdown.Item>
                                            <Dropdown.Item className="text-danger" onClick={() => handleDeleteReport(report.id)}>
                                                Hapus
                                            </Dropdown.Item>
                                        </Dropdown.Menu>
                                    </Dropdown>

                                    </td>
                                </tr>
                            ))
                        ) : (
                            <tr>
                                <td colSpan="7" className="text-center text-muted">
                                    Tidak ada laporan yang ditemukan.
                                </td>
                            </tr>
                        )}
                    </tbody>
                </Table>
            </div>

            {/* 🔥 Dropdown Status di Luar Tabel */}
            {showStatusDropdown && (
                <div
                    ref={dropdownRef}
                    className="position-fixed bg-white shadow p-2"
                    style={{
                        zIndex: 9999,
                        borderRadius: "5px",
                        width: "180px",
                        top: `${dropdownPosition.top}px`,
                        left: `${dropdownPosition.left}px`
                    }}
                >
                    <Dropdown.Menu show>
                        <Dropdown.Item onClick={() => setSelectedStatus("")}>
                            🔄 Reset Filter
                        </Dropdown.Item>
                        {Object.keys(statusMappings).map((status) => (
                            <Dropdown.Item 
                                key={status} 
                                onClick={() => {
                                    setSelectedStatus(status);
                                    setShowStatusDropdown(false);
                                }}
                            >
                                <Badge bg={statusMappings[status].color} className="me-2">
                                    {statusMappings[status].label}
                                </Badge>
                            </Dropdown.Item>
                        ))}
                    </Dropdown.Menu>
                </div>
            )}
        </Card>
    );
};

export default LaporanTable;
