import { useState } from "react";
import { Card, Table, Dropdown, Row, Col, InputGroup, Form, Button, Spinner } from "react-bootstrap";
import { BsThreeDotsVertical, BsEye, BsPencil, BsTrash } from "react-icons/bs";

const AnnouncementTable = ({ announcements, isLoading, initialLoadComplete, onView, onDelete, onEdit }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const API_BASE_URL = "http://localhost:3000";

  const filtered = announcements.filter((a) =>
    a.title.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">Daftar Pengumuman</h5>
          </Col>
          <Col xs={12} md={6} className="d-flex justify-content-md-end justify-content-center align-items-center">
            <div className="d-flex gap-2" style={{ maxWidth: "300px", width: "100%" }}>
              <InputGroup>
                <Form.Control
                  type="text"
                  placeholder="Cari berdasarkan judul..."
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
            </div>
          </Col>
        </Row>
      </Card.Header>

      <div className="table-responsive">
        <Table hover className="align-middle mb-0">
          <thead className="bg-light">
            <tr>
              <th>#</th>
              <th>Judul</th>
              <th>File</th>
              <th>Dibuat</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
  {isLoading ? (
    <tr>
      <td colSpan="5" className="text-center py-5">
        <Spinner animation="border" variant="primary" />
        <div className="text-muted mt-2">Memuat pengumuman...</div>
      </td>
    </tr>
  ) : filtered.length === 0 ? (
    <tr>
      <td colSpan="5" className="text-center text-muted py-5">
        Tidak ada pengumuman ditemukan.
      </td>
    </tr>
  ) : (
    filtered.map((a, i) => (
      <tr key={a.id}>
        <td>{i + 1}</td>
        <td>{a.title}</td>
        <td>
          {a.file ? (
            <a
              href={`${API_BASE_URL}/${a.file}`}
              target="_blank"
              rel="noreferrer"
            >
              📄 Lihat File
            </a>
          ) : (
            "-"
          )}
        </td>
        <td>{new Date(a.createdAt).toLocaleDateString("id-ID")}</td>
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
              <button className="dropdown-item d-flex align-items-center gap-2" onClick={() => onView(a.id)}>
                <BsEye /> Lihat Detail
              </button>
              <button className="dropdown-item d-flex align-items-center gap-2" onClick={() => onEdit(a)}>
                <BsPencil /> Edit
              </button>
              <button className="dropdown-item d-flex align-items-center gap-2 text-danger" onClick={() => onDelete(a)}>
                <BsTrash /> Hapus
              </button>
            </div>
          </div>
        </td>
      </tr>
    ))
  )}
</tbody>




        </Table>
      </div>
    </Card>
  );
};

export default AnnouncementTable;
