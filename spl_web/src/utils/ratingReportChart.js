export const renderRatingReportChart = (overviewData, selectedYear = "all") => {
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

  const ratingChartEl = document.querySelector("#ratingReportChart");
  if (!ratingChartEl || typeof ApexCharts === "undefined") return;

  const ratingByYear = overviewData?.ratingAnalytics?.averageRatingByYear || [];

  const filteredData = selectedYear === "all"
    ? ratingByYear
    : ratingByYear.filter((item) => item.year.toString() === selectedYear);

  const seriesData = filteredData.map((item) => ({
    x: item.year.toString(),
    y: parseFloat(item.avg_rating).toFixed(2),
  }));

  // Clear existing chart before rendering new
  ratingChartEl.innerHTML = "";

  const options = {
    series: [
      {
        name: "Rata-rata Rating",
        data: seriesData,
      },
    ],
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
            filename: `Rata_Rata_Rating_${selectedYear}`,
            columnDelimiter: ",",
            headerCategory: "Tahun",
            headerValue: "Rating",
          },
          svg: { filename: `Rata_Rata_Rating_${selectedYear}` },
          png: { filename: `Rata_Rata_Rating_${selectedYear}` },
        },
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "45%",
        borderRadius: 10,
        endingShape: "rounded",
      },
    },
    colors: [config.colors.primary],
    dataLabels: {
      enabled: true,
      formatter: (val) => `${val} / 5`,
      style: {
        fontSize: "13px",
        colors: [cardColor],
      },
    },
    xaxis: {
      categories: filteredData.map((r) => r.year.toString()),
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
      min: 0,
      max: 5,
      tickAmount: 5,
      labels: {
        style: {
          fontSize: "13px",
          colors: axisColor,
        },
        formatter: function (val) {
          return `${val.toFixed(1)}`;
        },
      },
    },
    grid: {
      borderColor: borderColor,
      padding: { top: 0, bottom: -10, left: 15, right: 15 },
    },
    stroke: {
      width: 4,
      curve: "smooth",
      lineCap: "round",
      colors: [cardColor],
    },
    legend: { show: false },
  };

  const chart = new ApexCharts(ratingChartEl, options);
  chart.render();
};
