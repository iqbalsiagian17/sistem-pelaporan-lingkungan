const { Report, RatingReport } = require("../../../models");
const { Op, Sequelize } = require("sequelize");

const getOverview = async (req, res) => {
  try {
    const now = new Date();
    const currentYear = now.getFullYear();
    const last24Hours = new Date(now.getTime() - 24 * 60 * 60 * 1000);

    // --- ANALISIS LAPORAN ---
    const totalReports = await Report.count();

    const completedReports = await Report.count({
      where: { status: { [Op.in]: ["completed", "closed"] } },
    });

    const inProgressReports = await Report.count({
      where: { status: { [Op.in]: ["verified", "in_progress"] } },
    });

    const rejectedReports = await Report.count({
      where: { status: "rejected" },
    });

    const newReports = await Report.count({
      where: { createdAt: { [Op.gte]: last24Hours } },
    });

    const urgentReports = await Report.count({
      where: {
        status: { [Op.in]: ["verified", "in_progress"] },
        createdAt: { [Op.gte]: last24Hours },
      },
    });

    const calculateCompletionRate = async () => {
      const startOfThisMonth = new Date(currentYear, now.getMonth(), 1);
      const startOfLastMonth = new Date(currentYear, now.getMonth() - 1, 1);
      const endOfLastMonth = new Date(startOfThisMonth.getTime() - 1);

      const completedThisMonth = await Report.count({
        where: {
          status: { [Op.in]: ["completed", "closed"] },
          updatedAt: { [Op.gte]: startOfThisMonth },
        },
      });

      const completedLastMonth = await Report.count({
        where: {
          status: { [Op.in]: ["completed", "closed"] },
          updatedAt: {
            [Op.between]: [startOfLastMonth, endOfLastMonth],
          },
        },
      });

      let percentageChange = 0;
      if (completedLastMonth > 0) {
        percentageChange =
          ((completedThisMonth - completedLastMonth) / completedLastMonth) * 100;
      } else if (completedThisMonth > 0) {
        percentageChange = 100;
      }

      return {
        completedThisMonth,
        percentageChange: Math.round(percentageChange),
      };
    };

    const {
      completedThisMonth: completionThisMonth,
      percentageChange: completionRate,
    } = await calculateCompletionRate();

    const startOfYear = new Date(currentYear, 0, 1);
    const endOfYear = new Date(currentYear, 11, 31, 23, 59, 59, 999);

    const monthlyReports = await Report.findAll({
      attributes: [
        [Sequelize.fn("MONTH", Sequelize.col("createdAt")), "month"],
        [Sequelize.fn("COUNT", Sequelize.col("id")), "count"],
      ],
      where: {
        createdAt: {
          [Op.between]: [startOfYear, endOfYear],
        },
      },
      group: ["month"],
      raw: true,
    });

    const chartData = Array(12).fill(0);
    monthlyReports.forEach((item) => {
      const monthIndex = item.month - 1;
      chartData[monthIndex] = parseInt(item.count);
    });

    // --- ANALISIS RATING ---

// 1. Rata-rata rating dari semua laporan (hanya yang is_latest = true)
const allRatingAvgResult = await RatingReport.findOne({
  attributes: [[Sequelize.fn("AVG", Sequelize.col("rating")), "avg_rating"]],
  where: {
    is_latest: true, // ✅ hanya rating terbaru
  },
  raw: true,
});
const averageRatingAll = parseFloat(allRatingAvgResult?.avg_rating || 0).toFixed(2);

// 2. Rata-rata rating per tahun (hanya yang is_latest = true)
const averageRatingByYear = await RatingReport.findAll({
  attributes: [
    [Sequelize.fn("YEAR", Sequelize.col("rated_at")), "year"],
    [Sequelize.fn("AVG", Sequelize.col("rating")), "avg_rating"],
    [Sequelize.fn("COUNT", Sequelize.col("id")), "jumlah_rating"],
  ],
  where: {
    is_latest: true, // ✅ hanya rating terbaru
  },
  group: ["year"],
  order: [["year", "ASC"]],
  raw: true,
});


    return res.json({
      totalReports,
      completedReports,
      inProgressReports,
      rejectedReports,
      newReports,
      urgentReports,
      completionRate,
      completionThisMonth,
      [`chart${currentYear}`]: chartData,
      ratingAnalytics: {
        averageRatingAll,
        averageRatingByYear,
      },
    });
  } catch (err) {
    console.error("Analytics error:", err);
    return res.status(500).json({ error: "Terjadi kesalahan server" });
  }
};

module.exports = { getOverview };
