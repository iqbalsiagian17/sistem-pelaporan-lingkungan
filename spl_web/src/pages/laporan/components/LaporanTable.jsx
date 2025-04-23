import { useState, useEffect, useRef } from "react";
import { Dropdown, Table, Badge, Card, Form, Row, Col, InputGroup, Button, Spinner } from "react-bootstrap";
import statusData from "../../../data/statusData.json";
import { exportReportsToExcel } from "../../../utils/exportReportsToExcel";
import CustomPagination from "../../../components/common/CustomPagination";
import ExportFilterModal from "../components/ExportFilterModal";

const LaporanTable = ({ reports, handleOpenDetailModal, handleOpenStatusModal, handleDeleteReport, isLoading }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedStatus, setSelectedStatus] = useState("");
  const [showStatusDropdown, setShowStatusDropdown] = useState(false);
  const [dropdownPosition, setDropdownPosition] = useState({ top: 0, left: 0 });
  const [currentPage, setCurrentPage] = useState(1);
  const [showExportModal, setShowExportModal] = useState(false);

  const reportsPerPage = 10;
  const dropdownRef = useRef(null);
  const statusHeaderRef = useRef(null);

  const statusMappings = statusData.statusMappings;

  const filteredReports = reports
    .slice()
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
    .filter(report => {
      const matchSearch = report.report_number.toLowerCase().includes(searchQuery.toLowerCase());
      const matchStatus = selectedStatus ? report.status === selectedStatus : true;
      return matchSearch && matchStatus;
    });

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

  const handleDropdownToggle = () => {
    if (statusHeaderRef.current) {
      const rect = statusHeaderRef.current.getBoundingClientRect();
      setDropdownPosition({
        top: rect.bottom + window.scrollY,
        left: rect.left + window.scrollX,
      });
    }
    setShowStatusDropdown(prev => !prev);
  };

  const indexOfLastReport = currentPage * reportsPerPage;
  const indexOfFirstReport = indexOfLastReport - reportsPerPage;
  const currentReports = filteredReports.slice(indexOfFirstReport, indexOfLastReport);
  const totalPages = Math.ceil(filteredReports.length / reportsPerPage);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const handleExportExcel = () => setShowExportModal(true);

  const handleFilteredExport = (filterOptions) => {
    const { status, dateFrom, dateTo, location } = filterOptions;

    let filtered = [...filteredReports];

    if (status) filtered = filtered.filter(r => r.status === status);
    if (dateFrom) filtered = filtered.filter(r => new Date(r.createdAt) >= new Date(dateFrom));
    if (dateTo) filtered = filtered.filter(r => new Date(r.createdAt) <= new Date(dateTo));
    if (location === "with_location") filtered = filtered.filter(r => r.latitude && r.longitude);
    if (location === "without_location") filtered = filtered.filter(r => !r.latitude && !r.longitude);

    exportReportsToExcel(filtered);
  };

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">Daftar Laporan</h5>
          </Col>
          <Col xs={12} md={6} className="d-flex justify-content-md-end justify-content-center align-items-center">
            <div className="d-flex gap-2" style={{ maxWidth: "400px", width: "100%" }}>
              <InputGroup>
                <Form.Control
                  type="text"
                  placeholder="Cari Nomor Laporan..."
                  value={searchQuery}
                  className="border-0 shadow-sm"
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
                <Button
                  variant="outline-secondary"
                  className="border-0 shadow-sm"
                  onClick={() => setSearchQuery("")}
                  title="Hapus Pencarian"
                >
                  <i className="bx bx-x" style={{ fontSize: "18px" }}></i>
                </Button>
              </InputGroup>

              <Button
                variant="success"
                className="border-0 shadow-sm d-flex align-items-center justify-content-center"
                style={{ width: "48px", height: "48px" }}
                onClick={handleExportExcel}
                title="Export Excel"
              >
                <i className="bx bx-spreadsheet" style={{ fontSize: "18px" }}></i>
              </Button>
            </div>
          </Col>
        </Row>
      </Card.Header>

      {/* Table Section */}
      <div className="table-responsive">
        {isLoading ? (
          <div className="d-flex justify-content-center align-items-center" style={{ minHeight: "300px" }}>
            <Spinner animation="border" variant="primary" />
          </div>
        ) : (
          <>
            <Table hover className="align-middle">
              <thead className="bg-light">
                <tr>
                  <th>No</th>
                  <th>Pelapor</th>
                  <th>Judul</th>
                  <th>Nomor</th>
                  <th>Diajukan</th>
                  <th ref={statusHeaderRef} className="position-relative">
                    <Button variant="light" size="sm" className="border-0" onClick={handleDropdownToggle}>
                      Status <i className="bx bx-filter-alt"></i>
                    </Button>
                  </th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody>
  {isLoading ? (
    <tr>
      <td colSpan="7" className="text-center py-5">
        <Spinner animation="border" variant="primary" />
        <div className="text-muted mt-2">Memuat data laporan...</div>
      </td>
    </tr>
  ) : currentReports.length > 0 ? (
    currentReports.map((report, index) => (
      <tr key={report.id}>
        <td>{indexOfFirstReport + index + 1}</td>
        <td>{report.user?.username || "-"}</td>
        <td><strong>{report.title || "-"}</strong></td>
        <td>{report.report_number || "-"}</td>
        <td>
          {new Date(report.createdAt).toLocaleDateString("id-ID")}{" "}
          {Date.now() - new Date(report.createdAt).getTime() < 24 * 60 * 60 * 1000 && (
            <span className="badge bg-success ms-1">Baru</span>
          )}
        </td>
        <td>
          <Badge bg={statusMappings[report.status]?.color || "secondary"} className="text-uppercase">
            {statusMappings[report.status]?.label || "Tidak Diketahui"}
          </Badge>
        </td>
        <td>
          <div className="dropdown">
            <button type="button" className="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
              <i className="bx bx-dots-vertical-rounded" style={{ fontSize: "18px" }}></i>
            </button>
            <div className="dropdown-menu dropdown-menu-end">
              <button className="dropdown-item" onClick={() => handleOpenDetailModal(report.id)}>
                <i className="bx bx-show me-1"></i> Lihat Laporan
              </button>
              <button className="dropdown-item" onClick={() => handleOpenStatusModal(report)}>
                <i className="bx bx-task me-1"></i> Tindak Lanjuti
              </button>
              <button className="dropdown-item text-danger" onClick={() => handleDeleteReport(report.id)}>
                <i className="bx bx-trash me-1"></i> Hapus
              </button>
            </div>
          </div>
        </td>
      </tr>
    ))
  ) : (
    <tr>
      <td colSpan="7" className="text-center text-muted py-5">
        Tidak ada laporan yang ditemukan.
      </td>
    </tr>
  )}
</tbody>

            </Table>

            {filteredReports.length > reportsPerPage && (
              <div className="d-flex justify-content-center my-3">
                <CustomPagination
                  currentPage={currentPage}
                  totalPages={totalPages}
                  onPageChange={paginate}
                />
              </div>
            )}
          </>
        )}
      </div>

      {/* Dropdown Status */}
      {showStatusDropdown && (
        <div
          ref={dropdownRef}
          className="position-fixed bg-white shadow p-2"
          style={{
            zIndex: 9999,
            borderRadius: "5px",
            width: "180px",
            top: `${dropdownPosition.top}px`,
            left: `${dropdownPosition.left}px`,
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

      {/* Export Filter Modal */}
      <ExportFilterModal
        show={showExportModal}
        onClose={() => setShowExportModal(false)}
        onExport={handleFilteredExport}
      />
    </Card>
  );
};

export default LaporanTable;
