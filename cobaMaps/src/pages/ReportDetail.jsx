import { useParams } from "react-router-dom";
import GoogleMapsIframe from "../components/maps/GoogleMapsIframe";

function ReportDetail() {
    const { id } = useParams(); // Ambil ID dari URL

    return (
        <div style={{ textAlign: "center", padding: "20px" }}>
            <h1>Detail Laporan</h1>
            <p>Menampilkan laporan dengan ID: {id}</p>
            <GoogleMapsIframe reportId={id} /> {/* Kirim ID ke GoogleMapsIframe */}
        </div>
    );
}

export default ReportDetail;
