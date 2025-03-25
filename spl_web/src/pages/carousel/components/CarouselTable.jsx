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

const CarouselTable = ({ carousels, onView, onEdit, onDelete }) => {
  const [search, setSearch] = useState("");

  const filtered = carousels.filter((item) =>
    item.title.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="fw-bold bg-light">
        <Row className="align-items-center">
          <Col md={6}>
            <h5 className="mb-0">🎞️ Daftar Carousel</h5>
          </Col>
          <Col md={6}>
            <InputGroup>
              <Form.Control
                placeholder="Cari berdasarkan judul..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="shadow-sm"
              />
              <Button
                variant="outline-secondary"
                onClick={() => setSearch("")}
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

export default CarouselTable;
