import { useState, useEffect } from "react";

function GoogleMapsIframe({ reportId }) {
    const [latitude, setLatitude] = useState(null);
    const [longitude, setLongitude] = useState(null);
    const [address, setAddress] = useState("");
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchReportData = async () => {
            try {
                const response = await fetch(`http://127.0.0.1:8000/api/reports/${reportId}`);
                const data = await response.json();

                if (data.report) {
                    setLatitude(data.report.latitude);
                    setLongitude(data.report.longitude);
                    setAddress(data.report.address);
                }
            } catch (error) {
                console.error("Gagal mengambil data laporan:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchReportData();
    }, [reportId]);

    if (loading) return <p>Loading...</p>;
    if (!latitude || !longitude) return <p>Tidak ada data lokasi.</p>;

    return (
        <div>
            <h2>Peta Lokasi Laporan</h2>
            <p><strong>Alamat:</strong> {address}</p>
            <iframe
                width="600"
                height="450"
                style={{ border: 0 }}
                loading="lazy"
                allowFullScreen
                referrerPolicy="no-referrer-when-downgrade"
                src={`https://www.google.com/maps?q=${latitude},${longitude}&hl=es;z=14&output=embed`}
            ></iframe>
        </div>
    );
}

export default GoogleMapsIframe;
