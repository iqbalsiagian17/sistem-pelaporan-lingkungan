import { Card, Table } from "react-bootstrap";

const ParameterTable = ({ parameters, onView, onEdit, onDelete }) => {
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
        {parameter && (
          <div className="dropdown">
            <button
              type="button"
              className="btn p-0 dropdown-toggle hide-arrow"
              data-bs-toggle="dropdown"
            >
              <i className="bx bx-dots-vertical-rounded" style={{ fontSize: "18px" }}></i>
            </button>
            <div className="dropdown-menu dropdown-menu-end">
              <button className="dropdown-item" onClick={() => onView(parameter)}>
                📄 Lihat Detail
              </button>
              <button className="dropdown-item" onClick={() => onEdit(parameter)}>
                ✏️ Edit
              </button>
              <button className="dropdown-item text-danger" onClick={() => onDelete(parameter)}>
                🗑️ Hapus
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
            {parameter ? (
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
                <td colSpan="7" className="text-center text-muted">
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
