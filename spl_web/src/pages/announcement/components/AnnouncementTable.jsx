import { useState } from "react";
import { Card, Table, Dropdown, Row, Col, InputGroup, Form, Button } from "react-bootstrap";

const AnnouncementTable = ({ announcements,onView, onDelete, onEdit }) => {
  const [searchQuery, setSearchQuery] = useState("");
  const API_BASE_URL = "http://69.62.82.58:3000"; 

  const filtered = announcements.filter((a) =>
    a.title.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          {/* 📋 Judul */}
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">
                Daftar Pengumuman
            </h5>
          </Col>

          {/* 🔍 Search + ❌ */}
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
            {filtered.length > 0 ? (
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
                        <i className="bx bx-dots-vertical-rounded" style={{ fontSize: "18px" }}></i>
                      </button>
                      <div className="dropdown-menu dropdown-menu-end">
                        <button className="dropdown-item" onClick={() => onView(a.id)}>
                          📄 Lihat Detail
                        </button>
                        <button className="dropdown-item" onClick={() => onEdit(a)}>
                          ✏️ Edit
                        </button>
                        <button
                          className="dropdown-item text-danger"
                          onClick={() => onDelete(a)}
                        >
                          🗑️ Hapus
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="6" className="text-center text-muted">
                  Tidak ada pengumuman ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>
    </Card>
  );
};

export default AnnouncementTable;
