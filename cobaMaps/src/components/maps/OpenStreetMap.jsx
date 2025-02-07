import { MapContainer, TileLayer, Marker } from "react-leaflet";
import { useState } from "react";

const center = { lat: -2.5489, lng: 118.0149 };

function OpenStreetMap() {
    const [position, setPosition] = useState(center);

    return (
        <MapContainer center={position} zoom={5} style={{ height: "400px", width: "100%" }}>
            <TileLayer
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            />
            <Marker position={position} />
        </MapContainer>
    );
}

export default OpenStreetMap;
