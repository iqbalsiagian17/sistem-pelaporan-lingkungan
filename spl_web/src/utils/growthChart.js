export const renderGrowthChart = (value = 0) => {
    const growthChartEl = document.querySelector("#growthChart");
    if (!growthChartEl || typeof window.ApexCharts === "undefined") return;
  
    // Ambil config dari window.config (seperti dashboardChart.js)
    const config = window.config || {
      colors: {
        primary: "#66bb6a",
        info: "#03c3ec",
        cardColor: "#fff",
        axisColor: "#ddd",
        borderColor: "#eceef1",
      },
    };
  
    const cardColor = config.colors.cardColor;
    const axisColor = config.colors.axisColor;
    const primaryColor = config.colors.primary;
  
    const options = {
      chart: {
        height: 150,
        type: "radialBar",
        sparkline: {
          enabled: true,
        },
      },
      series: [value],
      colors: [primaryColor],
      plotOptions: {
        radialBar: {
          hollow: {
            size: "55%",
            background: cardColor,
          },
          track: {
            background: config.colors.borderColor,
          },
          dataLabels: {
            name: {
              show: false,
            },
            value: {
              offsetY: 5,
              fontSize: "24px",
              color: axisColor,
              fontWeight: 500,
            },
          },
        },
      },
      stroke: {
        lineCap: "round",
      },
      labels: ["Progress"],
    };
  
    const chart = new window.ApexCharts(growthChartEl, options);
    chart.render();
  };
  