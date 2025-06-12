import { Card, Table, Spinner } from "react-bootstrap";
import { BsEye, BsPencil, BsTrash } from "react-icons/bs";


const ParameterTable = ({ parameters, isLoading, onView, onEdit, onDelete }) => {
  const parameter = parameters?.[0];

  const renderPreviewHTML = (htmlString) => {
    const temp = document.createElement("div");
    temp.innerHTML = htmlString;
    return temp.textContent?.slice(0, 100) + (temp.textContent.length > 100 ? "..." : "");
  };

  return (
    <Card className="shadow-sm border-0">
      <Card.Header className="fw-bold bg-light d-flex justify-content-between align-items-center">
        <h5 className="mb-0">Data Parameter Aplikasi</h5>
        {parameter && !isLoading && (
          <div className="dropdown">
            <button
              type="button"
              className="btn p-0 dropdown-toggle hide-arrow"
              data-bs-toggle="dropdown"
            >
              <i className="bx bx-dots-vertical-rounded" style={{ fontSize: "18px" }}></i>
            </button>
            <div className="dropdown-menu dropdown-menu-end">
              <button
                className="dropdown-item d-flex align-items-center gap-2"
                onClick={() => onView(parameter)}
              >
                <BsEye /> Lihat Detail
              </button>
              <button
                className="dropdown-item d-flex align-items-center gap-2"
                onClick={() => onEdit(parameter)}
              >
                <BsPencil /> Edit
              </button>
              <button
                className="dropdown-item d-flex align-items-center gap-2 text-danger"
                onClick={() => onDelete(parameter)}
              >
                <BsTrash /> Hapus
              </button>
            </div>

          </div>
        )}
      </Card.Header>

      <div className="table-responsive">
        <Table hover bordered className="mb-0 align-middle">
          <thead className="table-light text-center">
            <tr>
              <th style={{ width: "15%" }}>About</th>
              <th style={{ width: "15%" }}>Terms</th>
              <th style={{ width: "20%" }}>Report Guidelines</th>
              <th>Darurat</th>
              <th>Ambulans</th>
              <th>Polisi</th>
              <th>Pemadam</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan="7" className="text-center py-5">
                  <Spinner animation="border" variant="primary" />
                  <div className="text-muted mt-2">Memuat data parameter...</div>
                </td>
              </tr>
            ) : parameter ? (
              <tr>
                <td>{renderPreviewHTML(parameter.about)}</td>
                <td>{renderPreviewHTML(parameter.terms)}</td>
                <td>{renderPreviewHTML(parameter.report_guidelines)}</td>
                <td>{parameter.emergency_contact || "-"}</td>
                <td>{parameter.ambulance_contact || "-"}</td>
                <td>{parameter.police_contact || "-"}</td>
                <td>{parameter.firefighter_contact || "-"}</td>
              </tr>
            ) : (
              <tr>
                <td colSpan="7" className="text-center text-muted py-5">
                  Tidak ada data parameter ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </Table>
      </div>
    </Card>
  );
};

export default ParameterTable;
