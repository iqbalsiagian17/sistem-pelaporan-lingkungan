import { useEffect } from "react";
import { renderRatingYearChart } from "../../../utils/ratingYearChart";

const RatingYearChart = ({ ratingAnalytics }) => {
  useEffect(() => {
    if (ratingAnalytics) {
      renderRatingYearChart(ratingAnalytics);
    }
  }, [ratingAnalytics]);

  const averageRating = parseFloat(ratingAnalytics?.averageRatingAll || 0);

  const getEvaluationMessage = (rating) => {
    const messages = [
      { min: 4.5, text: "Luar Biasa, Sangat Memuaskan!", color: "success" },
      { min: 3.5, text: "Bagus, Tetap Pertahankan!", color: "primary" },
      { min: 2.5, text: "Cukup Baik, Perlu Peningkatan", color: "warning" },
      { min: 1.5, text: "Kurang Baik, Evaluasi Diperlukan", color: "danger" },
      { min: 0, text: "Sangat Buruk, Perlu Tindakan Serius", color: "danger" }
    ];
    
    return messages.find((msg) => rating >= msg.min) || messages[messages.length - 1];
  };
  

  const evaluation = getEvaluationMessage(averageRating);

  return (
    <div className="card h-100">
      <div className="row row-bordered g-0">
        <div className="col-md-8">
          <h5 className="card-header m-0 me-2 pb-3">
            Rata-rata Penilaian Masyarakat
          </h5>
          <div id="ratingYearChart" className="px-2" style={{ minHeight: "270px" }}></div>
        </div>
        <div className="col-md-4 d-flex flex-column justify-content-center align-items-center p-3">
          <div className="text-center">
            <h3 className="fw-bold mb-1 text-primary">
              {averageRating.toFixed(2)}/5
            </h3>
            <p className="text-muted small mb-0">
              Rata-rata Semua Rating
            </p>
            <h3 className="fw-bold mb-1 text-success mt-3">
              {ratingAnalytics?.averageRatingByYear.reduce((total, year) => total + (year.jumlah_rating || 0), 0)}
            </h3>
            <p className="text-muted small mb-0">
              Total Penilaian
            </p>
            <div className={`badge bg-label-${evaluation.color} mt-3`}>
              {evaluation.text}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RatingYearChart;
