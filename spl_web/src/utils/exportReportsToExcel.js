import * as XLSX from 'xlsx-js-style';
import { saveAs } from 'file-saver';

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

export const exportReportsToExcel = (reports) => {
  const data = reports.map((report) => ({
    "Pelapor": report.user?.email || report.user?.username || '-',
    "Nomor Laporan": report.report_number || '-',
    "Judul Laporan": report.title || '-',
    "Deskripsi": report.description || '-',
    "Tanggal Dibuat": report.createdAt ? new Date(report.createdAt).toLocaleDateString('id-ID') : '-',
    "Status": statusTranslations[report.status] || report.status || '-',
    "Desa/Kelurahan": report.village || '-',
    "Detail Lokasi": report.location_details || '-',
    "Latitude": report.latitude || '-',
    "Longitude": report.longitude || '-',
  }));

  const worksheet = XLSX.utils.json_to_sheet(data);

  worksheet['!cols'] = [
    { wch: 20 },
    { wch: 20 },
    { wch: 30 },
    { wch: 50 },
    { wch: 20 },
    { wch: 20 },
    { wch: 20 },
    { wch: 40 },
    { wch: 15 },
    { wch: 15 },
  ];

  const range = XLSX.utils.decode_range(worksheet['!ref']);

  // ✅ Header styling
  for (let C = range.s.c; C <= range.e.c; ++C) {
    const cellAddress = XLSX.utils.encode_cell({ r: 0, c: C });
    if (!worksheet[cellAddress]) continue;

    worksheet[cellAddress].s = {
      font: { bold: true, color: { rgb: "000000" } },
      fill: { patternType: "solid", fgColor: { rgb: "D3D3D3" } },
      alignment: { horizontal: "center", vertical: "center", wrapText: true },
      border: {
        top: { style: "thin", color: { rgb: "000000" } },
        right: { style: "thin", color: { rgb: "000000" } },
        bottom: { style: "thin", color: { rgb: "000000" } },
        left: { style: "thin", color: { rgb: "000000" } },
      },
    };
  }

  // ✅ Body styling
  for (let R = range.s.r + 1; R <= range.e.r; ++R) {
    for (let C = range.s.c; C <= range.e.c; ++C) {
      const cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
      if (!worksheet[cellAddress]) continue;

      worksheet[cellAddress].s = {
        alignment: { vertical: "top", wrapText: true },
        border: {
          top: { style: "thin", color: { rgb: "AAAAAA" } },
          right: { style: "thin", color: { rgb: "AAAAAA" } },
          bottom: { style: "thin", color: { rgb: "AAAAAA" } },
          left: { style: "thin", color: { rgb: "AAAAAA" } },
        },
      };
    }
  }

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Daftar Laporan');

  const excelBuffer = XLSX.write(workbook, {
    bookType: 'xlsx',
    type: 'array',
    cellStyles: true,
  });

  const blob = new Blob([excelBuffer], { type: 'application/octet-stream' });
  saveAs(blob, `Daftar_Laporan_${new Date().toISOString().slice(0, 10)}.xlsx`);
};
