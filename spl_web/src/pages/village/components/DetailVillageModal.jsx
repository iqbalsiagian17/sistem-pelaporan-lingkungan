import { useEffect, useRef } from "react";
import { Modal, Button } from "react-bootstrap";
import { MapContainer, TileLayer, GeoJSON, useMap } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

const FitToPolygon = ({ geojson }) => {
  const map = useMap();
  const layerRef = useRef(null);

  useEffect(() => {
    if (geojson?.type === "Polygon") {
      const layer = L.geoJSON({ type: "Feature", geometry: geojson });
      const bounds = layer.getBounds();
      if (bounds.isValid()) {
        map.fitBounds(bounds, { padding: [20, 20] });
      }
    }
  }, [geojson, map]);

  return null;
};

const DetailVillageModal = ({ show, onHide, village }) => {
  const boundary = village?.boundary;

  return (
    <Modal show={show} onHide={onHide} centered size="xl">
      <Modal.Header closeButton>
        <Modal.Title>Detail Desa</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {village ? (
          <>
            <p><strong>Nama:</strong> {village.name}</p>

            {boundary ? (
              <>
                <p><strong>Boundary (Peta):</strong></p>
                <div style={{ height: "400px", marginBottom: "16px", borderRadius: "6px", overflow: "hidden" }}>
                  <MapContainer
                    center={[2.32186, 99.06076]} // fallback center
                    zoom={15}
                    scrollWheelZoom={true}
                    style={{ height: "100%", width: "100%" }}
                  >
                    <TileLayer
                      attribution='&copy; OpenStreetMap contributors'
                      url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    />
                    <GeoJSON data={boundary} />
                    <FitToPolygon geojson={boundary} />
                  </MapContainer>
                </div>

                <p><strong>Boundary (GeoJSON):</strong></p>
                <pre style={{ whiteSpace: "pre-wrap", backgroundColor: "#f8f9fa", padding: "10px", borderRadius: "4px" }}>
                  {JSON.stringify(boundary, null, 2)}
                </pre>
              </>
            ) : (
              <p className="text-muted">Boundary belum tersedia.</p>
            )}
          </>
        ) : (
          <p className="text-muted">Data desa tidak ditemukan.</p>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Tutup
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default DetailVillageModal;
