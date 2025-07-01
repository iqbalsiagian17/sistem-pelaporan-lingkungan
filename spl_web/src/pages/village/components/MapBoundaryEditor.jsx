import { useEffect, useRef } from "react";
import {
  MapContainer,
  TileLayer,
  FeatureGroup,
  useMap,
  GeoJSON,
} from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "leaflet-draw/dist/leaflet.draw.js";
import "leaflet-draw/dist/leaflet.draw.css";

const DrawControl = ({ initialPolygon, onPolygonCreated }) => {
  const map = useMap();
  const drawnItems = useRef(new L.FeatureGroup());

  useEffect(() => {
    map.addLayer(drawnItems.current);

    const drawControl = new L.Control.Draw({
      edit: {
        featureGroup: drawnItems.current,
        poly: { allowIntersection: false },
      },
      draw: {
        polygon: true,
        marker: false,
        polyline: false,
        circle: false,
        rectangle: false,
        circlemarker: false,
      },
    });
    map.addControl(drawControl);

    // Tambahkan polygon lama (jika ada)
    if (initialPolygon && initialPolygon.type === "Polygon") {
      const geoJsonLayer = L.geoJSON({
        type: "Feature",
        geometry: initialPolygon,
      });
      geoJsonLayer.eachLayer((layer) => {
        drawnItems.current.addLayer(layer);
      });

      // Fit ke polygon bounds
      map.fitBounds(geoJsonLayer.getBounds());
    }

    // Saat polygon dibuat
    map.on(L.Draw.Event.CREATED, (e) => {
      drawnItems.current.clearLayers();
      drawnItems.current.addLayer(e.layer);
      const geojson = e.layer.toGeoJSON().geometry;
      onPolygonCreated(geojson);
    });

    map.on(L.Draw.Event.EDITED, (e) => {
      e.layers.eachLayer((layer) => {
        const geojson = layer.toGeoJSON().geometry;
        onPolygonCreated(geojson);
      });
    });

    return () => {
      map.removeControl(drawControl);
      map.removeLayer(drawnItems.current);
    };
  }, [map, initialPolygon, onPolygonCreated]);

  return null;
};

const MapBoundaryEditor = ({ initialPolygon, onPolygonCreated }) => {
  const defaultCenter = [-2.3345, 99.0833]; // Fallback Balige

  return (
    <div
      style={{
        height: "400px",
        width: "100%",
        borderRadius: "8px",
        overflow: "hidden",
      }}
    >
    <MapContainer
      center={[2.32186, 99.06076]} // ✅ pusat Balige
      zoom={15}
      scrollWheelZoom={true}
      style={{ height: "100%", width: "100%" }}
    >
      <TileLayer
        attribution='&copy; OpenStreetMap contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
        <FeatureGroup>
          <DrawControl
            initialPolygon={initialPolygon}
            onPolygonCreated={onPolygonCreated}
          />
        </FeatureGroup>
      </MapContainer>
    </div>
  );
};

export default MapBoundaryEditor;
