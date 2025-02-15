import { useState } from "react";


const ReportForm = () => {
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [date, setDate] = useState("");
    const [location, setLocation] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();
        console.log({ title, description, date, location });
        alert("Laporan berhasil dikirim!");
    };

    return (
        <div className="container mt-4 mb-5">
            <div className="card p-4 shadow-sm" style={{ maxWidth: "800px", margin: "auto", border: "none" }}>
                <div className="card-body">
                    <div className="p-3 text-dark mb-3" style={{ backgroundColor: "#f8fcff" }}>
                        <h5 className="mb-0 fw-bold text-dark">Sampaikan Laporan Anda</h5>
                    </div>

                    <div className="alert alert-light border">
                        <strong>Perhatikan Cara Menyampaikan Pengaduan yang Baik dan Benar</strong>
                        <button className="btn btn-light btn-sm float-end">❓</button>
                    </div>

                    <form onSubmit={handleSubmit}>
                        <div className="mb-3">
                            <input type="text" className="form-control" placeholder="Ketik Judul Laporan Anda *" required value={title} onChange={(e) => setTitle(e.target.value)} />
                        </div>
                        <div className="mb-3">
                            <textarea className="form-control" rows="4" placeholder="Ketik Isi Laporan Anda *" required value={description} onChange={(e) => setDescription(e.target.value)}></textarea>
                        </div>
                        <div className="mb-3">
                            <input type="date" className="form-control" required value={date} onChange={(e) => setDate(e.target.value)} />
                        </div>
                        <div className="mb-3">
                            <label className="form-label">Pilih Lokasi Kejadian *</label>
                            <select
                                className="form-select"
                                required
                                value={location}
                                onChange={(e) => setLocation(e.target.value)}
                            >
                                <option value="" disabled>Pilih Lokasi Kejadian *</option> {/* Tidak gunakan "selected" */}
                                <option value="Balige">Balige</option>
                                <option value="Laguboti">Laguboti</option>
                                <option value="Porsea">Porsea</option>
                            </select>
                        </div>

                        <div className="mb-3">
                            <label htmlFor="lampiran" className="form-label">Upload Lampiran</label>
                            <input type="file" className="form-control" id="lampiran" />
                        </div>

                        <button type="submit" className="btn btn-outline-dark w-100">LAPOR!</button>
                    </form>
                </div>
            </div>
        </div>

        
    );
};

export default ReportForm;
