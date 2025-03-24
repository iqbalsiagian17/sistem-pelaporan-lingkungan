import { useState } from "react";
import {
  Dropdown,
  Table,
  Card,
  Form,
  Row,
  Col,
  InputGroup,
  Button,
  Badge,
} from "react-bootstrap";

const UserTable = ({ users, onDelete, onBlock, onUnblock, onEdit }) => {
  const [searchQuery, setSearchQuery] = useState("");

  const filteredUsers = users.filter((user) =>
    user.username.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="fw-bold text-primary bg-light">
        <Row className="align-items-center g-2">
          <Col xs={12} md={6} className="text-center text-md-start">
            <h5 className="mb-0">👥 Daftar Pengguna</h5>
          </Col>

          <Col xs={12} md={6}>
            <InputGroup>
              <Form.Control
                type="text"
                placeholder="Cari berdasarkan username..."
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

      <div className="table-responsive">
        <Table hover className="align-middle">
          <thead className="bg-light">
            <tr>
              <th>#</th>
              <th>Username</th>
              <th>Email</th>
              <th>No HP</th>
              <th>Role</th>
              <th>Status Blokir</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.length > 0 ? (
              filteredUsers.map((user, index) => (
                <tr key={user.id}>
                  <td>{index + 1}</td>
                  <td>{user.username}</td>
                  <td>{user.email}</td>
                  <td>{user.phone_number}</td>
                  <td>
                    <Badge bg={user.type === 1 ? "primary" : "success"}>
                      {user.type === 1 ? "Admin" : "User"}
                    </Badge>
                  </td>
                  <td>
                    {user.blocked_until ? (
                      <Badge bg="danger">
                        Sampai {new Date(user.blocked_until).toLocaleDateString("id-ID")}
                      </Badge>
                    ) : (
                      <Badge bg="success">Aktif</Badge>
                    )}
                  </td>
                  <td>
                    <Dropdown align="end">
                      <Dropdown.Toggle
                        as="span"
                        style={{ cursor: "pointer", fontSize: "18px" }}
                      >
                        <i className="bx bx-dots-vertical-rounded"></i>
                      </Dropdown.Toggle>
                      <Dropdown.Menu align="end">
                        <Dropdown.Item onClick={() => onEdit(user)}>
                          ✏️ Edit
                        </Dropdown.Item>
                        <Dropdown.Item onClick={() => onDelete(user)}>
                          🗑️ Hapus
                        </Dropdown.Item>
                        {user.blocked_until ? (
                          <Dropdown.Item onClick={() => onUnblock(user)}>
                            ✅ Unblock
                          </Dropdown.Item>
                        ) : (
                          <Dropdown.Item onClick={() => onBlock(user)}>
                            🚫 Block
                          </Dropdown.Item>
                        )}
                      </Dropdown.Menu>
                    </Dropdown>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="7" className="text-center text-muted">
                  Tidak ada pengguna ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>
    </Card>
  );
};

export default UserTable;
