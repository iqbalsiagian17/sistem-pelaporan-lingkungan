import { useState } from "react";
import {
  Card,
  Table,
  Dropdown,
  Row,
  Col,
  InputGroup,
  Form,
  Button,
} from "react-bootstrap";

const MediaCarouselTable = ({ mediaCarousels = [], onView, onEdit, onDelete }) => {
  const [search, setSearch] = useState("");

  const filtered = mediaCarousels.filter((item) =>
    item.title.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="bg-light">
        <Row className="align-items-center">
          {/* 📋 Judul */}
          <Col xs={12} md={6} className="mb-2 mb-md-0 text-center text-md-start">
            <h5 className="mb-0 text-primary fw-bold">
               Daftar Media Carousel
            </h5>
          </Col>

          {/* 🔍 Search + ❌ */}
          <Col xs={12} md={6} className="d-flex justify-content-md-end justify-content-center align-items-center">
            <div className="d-flex gap-2" style={{ maxWidth: "300px", width: "100%" }}>
              <InputGroup>
                <Form.Control
                  type="text"
                  placeholder="Cari berdasarkan judul..."
                  value={search}
                  className="border-0 shadow-sm"
                  onChange={(e) => setSearch(e.target.value)}
                />
                <Button
                  variant="outline-secondary"
                  className="border-0 shadow-sm"
                  onClick={() => setSearch("")}
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
              <th>Deskripsi</th>
              <th>Gambar</th>
              <th>Dibuat</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {filtered.length > 0 ? (
              filtered.map((item, index) => (
                <tr key={item.id}>
                  <td>{index + 1}</td>
                  <td>{item.title}</td>
                  <td>{item.description}</td>
                  <td>
                        {item.image ? (
                            <img
                            src={`http://localhost:3000/${item.image}`}
                            alt="carousel"
                            style={{ width: "120px", height: "auto", objectFit: "cover", borderRadius: "6px" }}
                            />
                        ) : (
                            "-"
                        )}
                </td>

                  <td>
                    {new Date(item.createdAt).toLocaleDateString("id-ID", {
                      year: "numeric",
                      month: "short",
                      day: "numeric",
                    })}
                  </td>
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
                        <button className="dropdown-item" onClick={() => onView(item.id)}>
                          📄 Lihat Detail
                        </button>
                        <button className="dropdown-item" onClick={() => onEdit(item)}>
                          ✏️ Edit
                        </button>
                        <button
                          className="dropdown-item text-danger"
                          onClick={() => onDelete(item)}
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
                <td colSpan="5" className="text-center text-muted">
                  Tidak ada data carousel ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>
    </Card>
  );
};

export default MediaCarouselTable;
