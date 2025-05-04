export const renderDashboardChart = (overviewData) => {
  const currentYear = new Date().getFullYear();
  const previousYear = currentYear - 1;

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
  if (!totalRevenueChartEl || typeof ApexCharts === "undefined") return;

  const chartThisYear = overviewData[`chart${currentYear}`] || new Array(12).fill(0);
  const chartLastYear = overviewData[`chart${previousYear}`] || null;

  const series = [
    { name: `${currentYear}`, data: chartThisYear },
  ];

  if (chartLastYear && chartLastYear.some(value => value !== 0)) {
    series.push({ name: `${previousYear}`, data: chartLastYear });
  }

  const options = {
    series: series,
    chart: {
      height: 320,
      type: "bar",
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
            filename: `Total_Laporan_${currentYear}`,
            columnDelimiter: ',',
            headerCategory: 'Bulan',
            headerValue: 'Jumlah',
          },
          svg: { filename: `Total_Laporan_${currentYear}` },
          png: { filename: `Total_Laporan_${currentYear}` },
        },
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "35%",
        borderRadius: 8,
        borderRadiusApplication: "end",
        borderRadiusWhenStacked: "last",
      },
    },
    fill: {
      type: "gradient",
      gradient: {
        shade: "light",
        type: "vertical",
        shadeIntensity: 0.5,
        gradientToColors: [config.colors.primary, config.colors.info],
        inverseColors: false,
        opacityFrom: 0.85,
        opacityTo: 0.55,
        stops: [0, 90, 100],
      },
    },
    colors: [config.colors.primary, config.colors.info],
    dataLabels: {
      enabled: false,
    },
    stroke: {
      width: 3,
      curve: "smooth",
      lineCap: "round",
      colors: [cardColor],
    },
    legend: {
      show: series.length > 1,
      horizontalAlign: "left",
      position: "top",
      markers: { height: 8, width: 8, radius: 10, offsetX: -3 },
      labels: { colors: axisColor, useSeriesColors: false },
      itemMargin: { horizontal: 10 },
    },
    grid: {
      borderColor: borderColor,
      padding: { top: 0, bottom: -8, left: 20, right: 20 },
      strokeDashArray: 4,
    },
    xaxis: {
      categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      labels: {
        style: { fontSize: "13px", fontWeight: 500, colors: axisColor },
      },
      axisTicks: { show: false },
      axisBorder: { show: false },
    },
    yaxis: {
      labels: {
        style: { fontSize: "13px", fontWeight: 500, colors: axisColor },
        formatter: (val) => Math.round(val),
      },
    },
    tooltip: {
      theme: "light",
      y: {
        formatter: (val) => `${val} laporan`,
      },
    },
    states: {
      hover: { filter: { type: "lighten", value: 0.05 } },
      active: { filter: { type: "darken", value: 0.05 } },
    },
  };
  

  const chart = new ApexCharts(totalRevenueChartEl, options);
  chart.render();
};
