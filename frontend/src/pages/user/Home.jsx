import UserNavbar from "../../components/user/UserNavbar";
import UserFooter from "../../components/user/UserFooter";
import ReportForm from "../../components/user/ReportForm";
import TimelineSteps from "../../components/user/TimelineSteps";

const Home = () => {
    return (
        <>
            <UserNavbar />
            <main>
                <div className="container-fluid mt-5 p-5">
                    <div className="container mt-4 text-center">
                        <div className="content">
                            <h1 className="fw-bold">Layanan Laporan Masyarakat</h1>
                            <p className="text-muted">
                                Laporkan permasalahan lingkungan di sekitar Toba dan Danau Toba, seperti pencemaran air, pembuangan sampah ilegal, deforestasi, atau masalah lainnya yang berdampak pada ekosistem dan kehidupan masyarakat.
                            </p>
                        </div>
                    </div>
                </div>
                <ReportForm />
                <TimelineSteps />
                <UserFooter />
            </main>
        </>
    );
};

export default Home;
