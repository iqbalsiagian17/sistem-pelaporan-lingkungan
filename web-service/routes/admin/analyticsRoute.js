const express = require("express");
const router = express.Router();
const { getOverview } = require("../../controllers/admin/analytics/analyticsController");

router.get("/overview", getOverview);

module.exports = router;
