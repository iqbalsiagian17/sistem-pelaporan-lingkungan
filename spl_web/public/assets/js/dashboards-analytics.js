// utils/dashboardChart.js
import ApexCharts from "apexcharts";

export const renderDashboardChart = (chart2024 = [], chart2023 = []) => {
  const config = window.config || {
    colors: {
      primary: "#696cff",
      info: "#03c3ec",
      cardColor: "#fff",
      axisColor: "#ddd",
      borderColor: "#eceef1",
    },
  };

  const cardColor = config.colors.cardColor;
  const axisColor = config.colors.axisColor;
  const borderColor = config.colors.borderColor;

  const totalRevenueChartEl = document.querySelector("#totalRevenueChart");
  if (!totalRevenueChartEl) return;

  const options = {
    series: [
      { name: "2024", data: chart2024 },
      { name: "2023", data: chart2023 },
    ],
    chart: {
      height: 300,
      stacked: true,
      type: "bar",
      toolbar: { show: false },
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "33%",
        borderRadius: 12,
        startingShape: "rounded",
        endingShape: "rounded",
      },
    },
    colors: [config.colors.primary, config.colors.info],
    dataLabels: { enabled: false },
    stroke: {
      curve: "smooth",
      width: 6,
      lineCap: "round",
      colors: [cardColor],
    },
    legend: {
      show: true,
      horizontalAlign: "left",
      position: "top",
      markers: { height: 8, width: 8, radius: 12, offsetX: -3 },
      labels: { colors: axisColor },
      itemMargin: { horizontal: 10 },
    },
    grid: {
      borderColor: borderColor,
      padding: { top: 0, bottom: -8, left: 20, right: 20 },
    },
    xaxis: {
      categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      labels: {
        style: { fontSize: "13px", colors: axisColor },
      },
      axisTicks: { show: false },
      axisBorder: { show: false },
    },
    yaxis: {
      labels: {
        style: { fontSize: "13px", colors: axisColor },
      },
    },
    responsive: [], // Optional breakpoints
    states: {
      hover: { filter: { type: "none" } },
      active: { filter: { type: "none" } },
    },
  };

  const chart = new ApexCharts(totalRevenueChartEl, options);
  chart.render();
};
