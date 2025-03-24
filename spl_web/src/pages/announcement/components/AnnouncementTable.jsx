import { useState } from "react";
import { Card, Table, Dropdown, Row, Col, InputGroup, Form, Button } from "react-bootstrap";

const AnnouncementTable = ({ announcements,onView, onDelete, onEdit }) => {
  const [searchQuery, setSearchQuery] = useState("");

  const filtered = announcements.filter((a) =>
    a.title.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="fw-bold text-primary bg-light">
        <Row className="align-items-center g-2">
          <Col xs={12} md={6} className="text-center text-md-start">
            <h5 className="mb-0">📢 Daftar Pengumuman</h5>
          </Col>
          <Col xs={12} md={6}>
            <InputGroup>
              <Form.Control
                type="text"
                placeholder="Cari berdasarkan judul..."
                className="border-0 shadow-sm"
                value={searchQuery}
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
                      <a href={`/${a.file}`} target="_blank" rel="noreferrer">
                        📄 Lihat File
                      </a>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>{new Date(a.createdAt).toLocaleDateString("id-ID")}</td>
                  <td>
                    <Dropdown align="end">
                      <Dropdown.Toggle
                        as="span"
                        style={{ cursor: "pointer", fontSize: "18px" }}
                      >
                        <i className="bx bx-dots-vertical-rounded"></i>
                      </Dropdown.Toggle>
                      <Dropdown.Menu align="end">
                        <Dropdown.Item onClick={() => onView(a.id)}>📄 Lihat Detail</Dropdown.Item>
                        <Dropdown.Item onClick={() => onEdit(a)}>✏️ Edit</Dropdown.Item>
                        <Dropdown.Item className="text-danger" onClick={() => onDelete(a)}>
                          🗑️ Hapus
                        </Dropdown.Item>
                      </Dropdown.Menu>
                    </Dropdown>
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
