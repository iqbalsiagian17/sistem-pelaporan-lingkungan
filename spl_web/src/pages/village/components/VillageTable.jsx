import { useState } from "react";
import {
  Card,
  Table,
  Row,
  Col,
  InputGroup,
  Form,
  Button,
  Spinner,
} from "react-bootstrap";
import { BsThreeDotsVertical, BsPencil, BsTrash, BsEye } from "react-icons/bs";
import CustomPagination from "../../../components/common/CustomPagination"; // pastikan ini benar

const VillageTable = ({
  villages = [],
  isLoading,
  onView,
  onEdit,
  onDelete,
  currentPage,
  totalPages,
  setCurrentPage,
  search,
  setSearch,
}) => {
  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          <Col xs={12} md={6}>
            <h5 className="mb-0 text-primary fw-bold">Daftar Desa</h5>
          </Col>
          <Col xs={12} md={6} className="d-flex justify-content-md-end">
            <div style={{ maxWidth: "300px", width: "100%" }}>
              <InputGroup>
                <Form.Control
                  type="text"
                  placeholder="Cari berdasarkan nama..."
                  value={search}
                  onChange={(e) => {
                    setSearch(e.target.value);
                    setCurrentPage(1); // reset ke halaman pertama saat search
                  }}
                  className="border-0 shadow-sm"
                />
                <Button
                  variant="outline-secondary"
                  className="border-0 shadow-sm"
                  onClick={() => {
                    setSearch("");
                    setCurrentPage(1);
                  }}
                >
                  <i className="bx bx-x" style={{ fontSize: "18px" }}></i>
                </Button>
              </InputGroup>
            </div>
          </Col>
        </Row>
      </Card.Header>

      <div className="table-responsive">
        <Table hover className="align-middle mb-0">
          <thead className="bg-light">
            <tr>
              <th>No</th>
              <th>Nama Desa</th>
              <th>Koordinat (Polygon)</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan="4" className="text-center py-5">
                  <Spinner animation="border" variant="primary" />
                  <div className="text-muted mt-2">Memuat data desa...</div>
                </td>
              </tr>
            ) : villages.length > 0 ? (
              villages.map((item, index) => (
                <tr key={item.id}>
                  <td>{index + 1 + (currentPage - 1) * 10}</td>
                  <td>{item.name}</td>
                  <td>
                    {item.boundary && item.boundary.coordinates
                      ? `${item.boundary.coordinates[0].length} titik`
                      : "-"}
                  </td>
                  <td>
                    <div className="dropdown">
                      <button
                        type="button"
                        className="btn p-0 dropdown-toggle hide-arrow"
                        data-bs-toggle="dropdown"
                      >
                        <BsThreeDotsVertical size={18} />
                      </button>
                      <div className="dropdown-menu dropdown-menu-end">
                        <button
                          className="dropdown-item d-flex align-items-center gap-2"
                          onClick={() => onView(item.id)}
                        >
                          <BsEye /> Lihat Detail
                        </button>

                        <button
                          className="dropdown-item d-flex align-items-center gap-2"
                          onClick={() => onEdit(item)}
                        >
                          <BsPencil /> Edit
                        </button>
                        <button
                          className="dropdown-item d-flex align-items-center gap-2 text-danger"
                          onClick={() => onDelete(item)}
                        >
                          <BsTrash /> Hapus
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="4" className="text-center text-muted py-5">
                  Tidak ada data desa ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>

      {totalPages > 1 && (
        <div className="d-flex justify-content-center my-3">
          <CustomPagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={setCurrentPage}
          />
        </div>
      )}
    </Card>
  );
};

export default VillageTable;
