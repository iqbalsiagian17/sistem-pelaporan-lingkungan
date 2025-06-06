const cron = require("node-cron");
const { Op } = require("sequelize");
const { User, Notification } = require("../models");
const { sendNotificationToUser } = require("../services/firebaseService");

const campaignMessages = [
  // Bahasa Indonesia
  "🌱 Yuk, mulai jaga lingkungan dari rumah sendiri!",
  "🚯 Kalau ada sampah yang sulit dibersihkan sendiri, laporkan lewat Balige Bersih ya!",
  "📢 Balige yang bersih dimulai dari kamu. Jangan ragu laporkan!",
  "♻️ Ayo bantu menjaga kebersihan desa kita. Bisa mulai dari hal kecil.",
  "🌿 Nampak sampah menumpuk di tempat umum? Foto dan lapor aja!",
  "🧹 Jangan tunggu kotor makin parah. Bersihkan atau laporkan lewat aplikasi!",
  "🗑️ Buang sampah pada tempatnya, dan ajak yang lain juga!",
  "📸 Kalo nemu TPS liar atau tumpukan sampah, tinggal foto dan lapor ya.",
  "🌍 Bumi ini rumah kita bersama. Yuk, jaga bareng-bareng!",
  "💬 Suaramu penting. Satu laporanmu bisa bersihkan satu titik.",
  "🔔 Ada tumpukan sampah di selokan? Ayo laporkan biar segera ditangani!",
  "✨ Lingkungan yang bersih = hidup yang lebih nyaman dan sehat.",
  "👀 Nampak sampah di pinggir jalan? Jangan didiamkan, laporkan!",
  "🤝 Gotong royong jaga kampung itu keren. Aplikasi bisa bantu kalau nggak sanggup sendiri.",
  "🧴 Plastik berserakan di sungai? Foto dan kirim lewat Balige Bersih!",
  "🛑 Jangan biarkan lingkungan kita tercemar. Kamu bisa ambil peran!",
  "📲 Aplikasi Balige Bersih itu buat bantu kamu, pakai kalau butuh ya!",
  "🧠 Edukasi lingkungan dimulai dari laporan aksi nyata.",
  "🌤️ Bersihkan yang bisa dibersihkan, dan laporkan yang tidak bisa sendiri.",
  "📍 Kalau ada yang buang sampah sembarangan, jangan diem aja. Laporkan.",
  "🗣️ Nggak tahu harus lapor ke siapa? Langsung aja via aplikasimu!",
  "📦 Sampah besar atau berat? Kamu gak harus sendiri, cukup laporkan.",
  "👣 Jejakmu hari ini bisa jaga bumi besok. Mulai dari satu laporan.",
  "🙌 Nggak ada yang terlalu kecil buat dilaporkan. Kalau ganggu lingkungan, laporkan aja.",
  "🌀 Lihat bak sampah penuh? Jangan lewatkan, fotoin dan kirim laporannya!",
  "💚 Kalau bukan kita, siapa lagi? Kalau bukan sekarang, kapan lagi?",
  "🪣 Yuk, bersih-bersih tiap hari. Tapi kalau nggak bisa bersihkan sendiri, gunakan aplikasi ya.",
  "📞 Jangan bingung cari nomor petugas. Satu klik lapor dari aplikasi cukup.",
  "🏘️ Bersih itu sehat. Tapi tanggung jawab kita bersama.",

  // Bahasa Batak Toba ringan
  "🧹 Jaga do hita lingkungan on, jala boi ma mambahen partongtongan na sehat.",
  "📲 Adong rura sampah di huta? Lapor ma tu aplikasi Balige Bersih.",
  "🌿 Unang jadi na diam. Ai nunga adong aplikasi dohot petugas na siap.",
  "🗑️ Songon naeng, buang do sampah tu tempatna, unang tu sisi jalan!",
  "📸 Tarsongon tumpak-tumpak sampah? Foto ma, lapor ma gabe tarsolusian.",
  "🗣️ Adong do pangula tu nasida, jala dohot aplikasi i. Lapor ma sude na dokkon.",
  "🤝 Dohot hita marsatu mangalehon hohot tu lingkungan huta.",
  "🌤️ Hape dang sanggup marsihkan dope? Lapor ma, ai adong do tim na tarima.",
  "🔔 Di jabu, di huta, di jalan — tarbagot do hita mangalehon padan.",
  "🌱 Laporkan dope rura na dang sanggup dibersihkan sendiri. Ai unang tunggu parjolo parjolo.",
];


function getRandomMessage() {
  return campaignMessages[Math.floor(Math.random() * campaignMessages.length)];
}

function getRandomSubset(arr, percentage = 0.5) {
  const shuffled = [...arr].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, Math.ceil(arr.length * percentage));
}

// Jalankan cron pada 08:00, 12:00, 16:00 setiap hari
cron.schedule("48 14 * * *", async () => {
  const now = new Date();
  const hour = now.getHours();
  const label = `${hour}:00`;

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 999);


  try {
    const allUsers = await User.findAll({
      where: {
        type: 0,
        fcm_token: { [Op.ne]: null },
      },
    });

    // Ambil subset user secara acak (misal 50%)
    const targetUsers = allUsers; // Kirim ke semua user


    for (const user of targetUsers) {

      const message = getRandomMessage();

      // Cek apakah user sudah dapat notifikasi campaign hari ini
      const existing = await Notification.findOne({
        where: {
          user_id: user.id,
          type: "campaign",
          createdAt: { [Op.between]: [todayStart, todayEnd] },
          message, // sama persis
        },
      });

      if (existing) continue;

      await Notification.create({
        user_id: user.id,
        title: "Ayo Jaga Lingkungan!",
        message,
        type: "campaign",
        sent_by: "system",
        role_target: "user",
      });

      await sendNotificationToUser(user.fcm_token, "Ayo Jaga Lingkungan!", message, {
        type: "campaign",
      });
    }

    console.log(`✅ Kampanye '${message}' dikirim ke ${targetUsers.length} user pada ${label}.`);
  } catch (err) {
    console.error("❌ Gagal kirim kampanye:", err);
  }
});
