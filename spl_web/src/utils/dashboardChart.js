export const renderDashboardChart = (overviewData) => {
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

  const chartEl = document.querySelector("#totalRevenueChart");
  if (!chartEl || typeof ApexCharts === "undefined") return;

  chartEl.innerHTML = "";

  // Ambil hanya 1 tahun yang dipilih
  const year = Object.keys(overviewData)[0]?.replace("chart", "") || "";
  const data = overviewData[`chart${year}`] || [];

  const series = [
    {
      name: year,
      data,
    },
  ];

  const options = {
    series,
    chart: {
      type: "bar",
      height: 300,
      toolbar: {
        show: true,
        tools: {
          download: true,
          selection: false,
          zoom: false,
          zoomin: false,
          zoomout: false,
          pan: false,
          reset: false,
        },
        export: {
          csv: {
            filename: `Total_Laporan_${year}`,
            columnDelimiter: ",",
            headerCategory: "Bulan",
            headerValue: "Jumlah",
          },
          svg: { filename: `Total_Laporan_${year}` },
          png: { filename: `Total_Laporan_${year}` },
        },
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "95%",
        borderRadius: 10,
        endingShape: "rounded",
        borderRadiusApplication: "end",
      },
    },
    colors: [config.colors.primary],
    dataLabels: {
      enabled: true,
      style: {
        fontSize: "13px",
        colors: [cardColor],
      },
    },
    stroke: {
      width: 4,
      curve: "smooth",
      lineCap: "round",
      colors: [cardColor],
    },
    xaxis: {
      categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      labels: {
        style: {
          fontSize: "13px",
          colors: axisColor,
        },
      },
      axisTicks: { show: false },
      axisBorder: { show: false },
    },
    yaxis: {
      labels: {
        style: {
          fontSize: "13px",
          colors: axisColor,
        },
        formatter: (val) => Math.round(val),
      },
    },
    grid: {
      borderColor,
      padding: { top: 0, bottom: -10, left: 15, right: 15 },
    },
    legend: {
      show: false,
    },
    tooltip: {
      theme: "light",
      y: {
        formatter: (val) => `${val} laporan`,
      },
    },
  };

  const chart = new ApexCharts(chartEl, options);
  chart.render();
};
