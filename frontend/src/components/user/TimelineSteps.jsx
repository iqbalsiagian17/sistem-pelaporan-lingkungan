import "../../style/user/timelinesteps.css";
const TimelineSteps = () => {
    return (
        <div className="container mt-5">
            <div className="timeline-steps">
                <div className="timeline-step">
                    <div className="timeline-content">
                        <div className="inner-circle"></div>
                        <p className="h6 mt-3 mb-1">Tulis Laporan</p>
                        <p className="h6 text-muted mb-0">Laporkan keberadaan Isu Lingkungan di sekitar Danau Toba dengan jelas dan lengkap.</p>
                    </div>
                </div>
                <div className="timeline-step">
                    <div className="timeline-content">
                        <div className="inner-circle"></div>
                        <p className="h6 mt-3 mb-1">Proses Verifikasi</p>
                        <p className="h6 text-muted mb-0">Laporan akan diverifikasi oleh Dinas Lingkungan Hidup Toba dalam 1 hari.</p>
                    </div>
                </div>
                <div className="timeline-step">
                    <div className="timeline-content">
                        <div className="inner-circle"></div>
                        <p className="h6 mt-3 mb-1">Tindak Lanjut</p>
                        <p className="h6 text-muted mb-0">Dinas akan menindaklanjuti laporan dan mengirim tim terkait dalam waktu 2 hari.</p>
                    </div>
                </div>
                <div className="timeline-step">
                    <div className="timeline-content">
                        <div className="inner-circle"></div>
                        <p className="h6 mt-3 mb-1">Beri Tanggapan</p>
                        <p className="h6 text-muted mb-0">Pelapor dapat memberikan umpan balik terhadap tindakan yang telah dilakukan.</p>
                    </div>
                </div>
                <div className="timeline-step">
                    <div className="timeline-content">
                        <div className="inner-circle"></div>
                        <p className="h6 mt-3 mb-1">Selesai</p>
                        <p className="h6 text-muted mb-0">Laporan ditutup setelah Isu Lingkungan berhasil dibersihkan oleh tim terkait.</p>
                    </div>
                </div>
            </div>
            <div className="d-flex flex-column justify-content-center align-items-center mb-5">
                <a href="#" className="btn btn-custom">Pelajari Lebih Lanjut</a>
            </div>
        </div>
    );
};

export default TimelineSteps;
