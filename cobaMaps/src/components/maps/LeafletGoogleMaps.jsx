import { MapContainer, TileLayer, Marker } from "react-leaflet";
import { useState } from "react";

const center = { lat: -2.5489, lng: 118.0149 };

function LeafletGoogleMaps() {
    const [position, setPosition] = useState(center);

    return (
        <MapContainer center={position} zoom={5} style={{ height: "400px", width: "100%" }}>
            <TileLayer
                url="http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}"
                attribution='&copy; <a href="https://www.google.com/maps">Google Maps</a>'
                subdomains={["mt0", "mt1", "mt2", "mt3"]}
            />
            <Marker position={position} />
        </MapContainer>
    );
}

export default LeafletGoogleMaps;
