export const renderRatingYearChart = (ratingAnalytics) => {
    const config = window.config || {
      colors: {
        primary: "#696cff",
        info: "#03c3ec",
        cardColor: "#fff",
        axisColor: "#ddd",
        borderColor: "#eceef1",
      },
    };
  
    const ratingYearChartEl = document.querySelector("#ratingYearChart");
    if (!ratingYearChartEl || typeof ApexCharts === "undefined") return;
  
    const years = ratingAnalytics.averageRatingByYear.map((item) => item.year.toString());
    const avgRatings = ratingAnalytics.averageRatingByYear.map((item) => parseFloat(item.avg_rating));
    const jumlahRatings = ratingAnalytics.averageRatingByYear.map((item) => item.jumlah_rating);
  
    const options = {
      series: [
        {
          name: "Rata-rata Rating",
          data: avgRatings
        },
        {
          name: "Jumlah Rating",
          data: jumlahRatings
        }
      ],
      chart: {
        height: 280,
        stacked: false,
        type: 'bar',
        toolbar: { show: false }
      },
      plotOptions: {
        bar: {
          horizontal: false,
          columnWidth: '33%',
          borderRadius: 12,
          startingShape: 'rounded',
          endingShape: 'rounded'
        }
      },
      colors: [config.colors.primary, config.colors.info],
      dataLabels: { enabled: true },
      stroke: {
        curve: 'smooth',
        width: 6,
        lineCap: 'round',
        colors: [config.colors.cardColor]
      },
      legend: {
        show: true,
        horizontalAlign: 'left',
        position: 'top',
        markers: {
          height: 8,
          width: 8,
          radius: 12,
          offsetX: -3
        },
        labels: {
          colors: config.colors.axisColor
        },
        itemMargin: { horizontal: 10 }
      },
      grid: {
        borderColor: config.colors.borderColor,
        padding: {
          top: 0,
          bottom: -8,
          left: 20,
          right: 20
        }
      },
      xaxis: {
        categories: years,
        labels: {
          style: {
            fontSize: '13px',
            colors: config.colors.axisColor
          }
        },
        axisTicks: { show: false },
        axisBorder: { show: false }
      },
      yaxis: {
        labels: {
          style: {
            fontSize: '13px',
            colors: config.colors.axisColor
          }
        }
      },
      responsive: [
        {
          breakpoint: 991,
          options: {
            plotOptions: {
              bar: {
                borderRadius: 10,
                columnWidth: '40%'
              }
            }
          }
        },
        {
          breakpoint: 576,
          options: {
            plotOptions: {
              bar: {
                borderRadius: 10,
                columnWidth: '50%'
              }
            }
          }
        }
      ],
      states: {
        hover: { filter: { type: 'none' } },
        active: { filter: { type: 'none' } }
      }
    };
  
    const chart = new ApexCharts(ratingYearChartEl, options);
    chart.render();
  };
  