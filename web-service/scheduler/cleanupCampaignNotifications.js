const cron = require("node-cron");
const { Notification } = require("../models");

// Cron: Setiap Minggu jam 03:00
cron.schedule("0 3 * * 0", async () => {
  try {
    const deletedCount = await Notification.destroy({
      where: { type: "campaign" },
    });

    console.log(`🧹 ${deletedCount} notifikasi campaign dihapus seluruhnya`);
  } catch (err) {
    console.error("❌ Gagal menghapus notifikasi campaign:", err);
  }
});
