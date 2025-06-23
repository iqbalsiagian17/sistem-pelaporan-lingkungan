import { useState, useEffect } from "react";
import { renderDashboardChart } from "../../../utils/dashboardChart";

const ChartCard = ({ allReports, overviewData, currentYear }) => {
  const allYears = Object.keys(overviewData || {})
    .filter((key) => key.startsWith("chart"))
    .map((key) => key.replace("chart", ""))
    .sort();

  const initialYear = allYears.includes(currentYear) ? currentYear : allYears[0] || "";
  const [selectedYear, setSelectedYear] = useState(initialYear);

  const processedReports = allReports.filter((report) =>
    ["in_progress", "completed", "closed"].includes(report.status)
  ).length;

  const unprocessedReports = allReports.filter((report) =>
    ["pending", "verified"].includes(report.status)
  ).length;

  const totalValidReports = processedReports + unprocessedReports;

  const completionPercentage =
    totalValidReports > 0
      ? Math.round((processedReports / totalValidReports) * 100)
      : 0;

  const isDataEmpty = totalValidReports === 0;

  const dropdownYears = allYears.filter((year) => year !== currentYear);

useEffect(() => {
  if (!overviewData || !selectedYear) return;

  const chartKey = `chart${selectedYear}`;
  const data = overviewData[chartKey];
  if (!data || !Array.isArray(data)) return;

  const timeout = setTimeout(() => {
    renderDashboardChart({ [chartKey]: data });
  }, 300); // Beri delay agar layout benar-benar stabil

  return () => clearTimeout(timeout);
}, [selectedYear, overviewData]);

  return (
    <div className="card h-100">
      <div className="row row-bordered g-0 h-100">
        <div className="col-md-8">
          <div className="d-flex justify-content-between align-items-center px-3 pt-3">
            <h5 className="card-title m-0">Total Laporan ({selectedYear})</h5>
            {allYears.length > 1 && (
              <select
                className="form-select w-auto"
                value={selectedYear}
                onChange={(e) => setSelectedYear(e.target.value)}
              >
                {allYears.map((year) => (
                  <option key={year} value={year}>
                    {year}
                  </option>
                ))}
              </select>
            )}
          </div>

          {!isDataEmpty && (
            <div style={{ overflowX: "auto", paddingRight: "1rem" }}>
              <div
                id="totalRevenueChart"
                style={{ minWidth: "720px", height: "300px" }}
              ></div>
            </div>
          )}
        </div>

        {!isDataEmpty && (
          <div className="col-md-4 d-flex flex-column justify-content-center align-items-center p-3">
            <div id="growthChart"></div>
            <div className="text-center">
              <h3 className="fw-bold mb-1 text-success">
                {completionPercentage}%
              </h3>
              <p className="text-muted small mb-0">Laporan Sudah Di Proses</p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ChartCard;
