import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

const BASE_URL = "http://localhost:3000"; // ✅ Ganti sesuai env (prod/dev)

const statusTranslations = {
  pending: "Menunggu Verifikasi",
  verified: "Sudah Diverifikasi",
  in_progress: "Sedang Diproses",
  completed: "Selesai",
  closed: "Ditutup",
  rejected: "Ditolak",
  canceled: "Dibatalkan",
  reopened: "Dibuka Ulang",
};


export const generatePDFManually = async (report) => {
  const doc = new jsPDF();

  // 🟩 Header Global
const addHeader = () => {
  // 🔹 Nama Aplikasi besar dan menonjol
  doc.setFontSize(18);
  doc.setFont(undefined, 'bold');
  doc.text("BaligeBersih", 105, 14, { align: 'center' });

  // 🔹 Subjudul atau slogan opsional
  doc.setFontSize(10);
  doc.setFont(undefined, 'normal');
  doc.text("Dinas Lingkungan Hidup Kabupaten Toba", 105, 20, { align: 'center' });
  doc.text("Sibola Hotangsas, Balige, Toba, Sumatera Utara", 105, 25, { align: 'center' });

  // 🔹 Garis pemisah
  doc.setLineWidth(0.5);
  doc.line(14, 29, 195, 29);
};



addHeader(); // 🟦 Tambahkan header di halaman pertama


  const sectionTitle = (text, y) => {
    doc.setFontSize(12);
    doc.setFont(undefined, 'bold');
    doc.text(text, 14, y);
    doc.setFont(undefined, 'normal');
  };

  let y = 35;

  // 🟦 Judul
  doc.setFontSize(16);
  doc.text('Detail Laporan', 14, y);
  y += 10;

  // 🔹 Informasi Laporan
  sectionTitle("Informasi Laporan", y); y += 6;
  const info = [
    ["Judul Laporan", report.title],
    ["Pelapor", report.user?.username || "-"],
    ["Email", report.user?.email || "-"],
    ["Nomor Laporan", report.report_number],
    ["Dibuat Pada", new Date(report.createdAt).toLocaleString()],
    ["Aduan", report.description || "-"]
  ];
  autoTable(doc, {
    startY: y,
    theme: 'striped',
    styles: { fontSize: 10 },
    head: [['Label', 'Isi']],
    body: info,
  });
  y = doc.lastAutoTable.finalY + 8;

  // 🔹 Lokasi
  y += 8;
  sectionTitle("Lokasi", y); y += 6;
  const lokasiInfo = [
    ["Detail Lokasi", report.location_details || "-"],
    ["Latitude", report.latitude || "-"],
    ["Longitude", report.longitude || "-"],
    ["Link Google Maps", `https://maps.google.com/?q=${report.latitude},${report.longitude}`],
  ];
  autoTable(doc, {
    startY: y,
    theme: 'striped',
    styles: { fontSize: 10 },
    head: [['Label', 'Isi']],
    body: lokasiInfo,
  });
  y = doc.lastAutoTable.finalY + 8;

  // 🔹 Penilaian Pelapor
  sectionTitle("Penilaian Pelapor", y); y += 6;
  const rating = report.rating?.rating ?? null;
  const ratingStars = rating !== null ? `${rating}/5` : "Belum ada penilaian";
  const review = report.rating?.review || "-";
  autoTable(doc, {
    startY: y,
    theme: 'striped',
    head: [['Rating', 'Review']],
    body: [[ratingStars, review]],
    styles: { fontSize: 10 },
  });
  y = doc.lastAutoTable.finalY + 10;

  // 🔹 Lampiran Gambar
  sectionTitle("Lampiran Bukti Laporan", y);
  y += 6;

const imageAttachments = report.attachments?.filter((a) => /\.(jpe?g|png)$/i.test(a.file)) || [];
const pageHeight = doc.internal.pageSize.height;

let imageWidth = 60;
let imageHeight = 45;
let gapX = 10;
let x = 14; // posisi kiri
let startY = y; // posisi atas

for (let i = 0; i < imageAttachments.length; i++) {
  try {
    const rawPath = imageAttachments[i].file;
    const imageUrl = rawPath.startsWith("http") ? rawPath : `${BASE_URL}/${rawPath}`;

    const response = await fetch(imageUrl, { mode: 'cors' });
    const blob = await response.blob();

    const base64 = await new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => resolve(reader.result);
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });

    if (base64) {
      // ⬇️ Cek jika tinggi berikutnya melebihi halaman
      if (startY + imageHeight + 20 > pageHeight) {
        doc.addPage();
        startY = 10;
      }

      doc.addImage(base64, 'JPEG', x, startY, imageWidth, imageHeight);
      doc.text(`Lampiran ${i + 1}`, x, startY + imageHeight + 5);

      // ⬅️ Geser ke kolom kanan (jika saat ini di kiri)
      if (x === 14) {
        x = 14 + imageWidth + gapX; // ke kanan
      } else {
        // ⬇️ Jika sudah dua gambar (kanan), pindah ke baris bawah
        x = 14; 
        startY += imageHeight + 20;
      }
    }
  } catch (error) {
    console.warn(`❌ Gagal memuat gambar lampiran ke-${i + 1}:`, error);
  }
}

// 🔚 Sinkronkan posisi Y setelah semua gambar ditambahkan
if (x === 14) {
  // Artinya gambar terakhir berada di kiri → sudah turun ke baris baru
  y = startY;
} else {
  // Artinya gambar terakhir berada di kanan → perlu tambah tinggi
  y = startY + imageHeight + 20;
}


sectionTitle("Riwayat Perubahan Status", y);
y += 6;

const statusHistories = report.statusHistory || [];
if (statusHistories.length > 0) {
const statusRows = statusHistories.map((s) => [
  new Date(s.createdAt).toLocaleString(),
  statusTranslations[s.previous_status] || s.previous_status || '-',
  statusTranslations[s.new_status] || s.new_status || '-',
  s.message || '-'
]);

  autoTable(doc, {
    startY: y,
    theme: 'grid',
    styles: { fontSize: 10 },
    head: [['Waktu', 'Dari', 'Ke', 'Catatan']],
    body: statusRows,
  });

  y = doc.lastAutoTable.finalY + 10;
} else {
  doc.text("Belum ada riwayat status.", 14, y);
  y += 10;
}

// 🔹 Bukti Tindakan dari Admin
sectionTitle("Bukti Tindakan", y);
y += 6;

const completedStatuses = (report.statusHistory || []).filter(
  (s) => s.new_status === "completed"
);

const allEvidences = report.evidences || []; // pastikan report.evidences sudah dimuat di backend

for (let idx = 0; idx < completedStatuses.length; idx++) {
  const current = completedStatuses[idx];
  const next = completedStatuses[idx + 1];
  const start = new Date(current.createdAt);
  const end = next ? new Date(next.createdAt) : new Date("9999-12-31T23:59:59Z");

  const evidencesForStatus = allEvidences.filter((ev) => {
    const evDate = new Date(ev.createdAt);
    return evDate >= start && evDate < end;
  });

  if (evidencesForStatus.length > 0) {
    doc.setFont(undefined, 'bold');
    doc.text(`Status "${statusTranslations[current.new_status] || current.new_status}" pada ${start.toLocaleString()}`, 14, y);
    doc.setFont(undefined, 'normal');
    y += 6;

    let x = 14;
    let localY = y;
    for (let i = 0; i < evidencesForStatus.length; i++) {
      const ev = evidencesForStatus[i];
      const imageUrl = ev.file.startsWith("http") ? ev.file : `${BASE_URL}/${ev.file}`;

      try {
        const response = await fetch(imageUrl);
        const blob = await response.blob();

        const base64 = await new Promise((resolve, reject) => {
          const reader = new FileReader();
          reader.onloadend = () => resolve(reader.result);
          reader.onerror = reject;
          reader.readAsDataURL(blob);
        });

        if (base64) {
          const pageHeight = doc.internal.pageSize.height;
          const imageHeight = 45;
          const imageWidth = 60;
          const gapX = 10;

          if (localY + imageHeight + 20 > pageHeight) {
            doc.addPage();
            localY = 10;
          }

          doc.addImage(base64, 'JPEG', x, localY, imageWidth, imageHeight);

          if (x === 14) {
            x = 14 + imageWidth + gapX;
          } else {
            x = 14;
            localY += imageHeight + 20;
          }
        }
      } catch (err) {
        console.warn("❌ Gagal memuat evidence:", err);
      }
    }

    y = localY + 10;
  }
}


  // ⬇️ Simpan PDF
  doc.save(`Laporan_${report?.report_number || "laporan"}.pdf`);
};
