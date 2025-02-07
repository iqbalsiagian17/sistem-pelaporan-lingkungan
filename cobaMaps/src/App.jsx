import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import GoogleMapsIframe from "./components/maps/GoogleMapsIframe";
import LeafletGoogleMaps from "./components/maps/LeafletGoogleMaps";
import OpenStreetMap from "./components/maps/OpenStreetMap";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import Home from "./pages/Home";
import Reports from "./pages/Reports";
import ReportDetail from "./pages/ReportDetail"; // Halaman detail laporan
import NotFound from "./pages/NotFound";

function App() {
    return (
        <Router>
            <Navbar />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/reports" element={<Reports />} />
                <Route path="/reports/:id" element={<ReportDetail />} /> {/* Halaman Detail Laporan */}
                <Route path="/maps/google" element={<GoogleMapsIframe />} />
                <Route path="/maps/leaflet" element={<LeafletGoogleMaps />} />
                <Route path="/maps/openstreet" element={<OpenStreetMap />} />
                <Route path="*" element={<NotFound />} />
            </Routes>
            <Footer />
        </Router>
    );
}

export default App;
