import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

export const exportReportsToExcel = (reports) => {
  const data = reports.map((report) => ({
    "Pelapor": report.user?.email || report.user?.username || '-',
    "Nomor Laporan": report.report_number || '-',
    "Judul Laporan": report.title || '-',
    "Deskripsi": report.description || '-',
    "Tanggal Dibuat": report.createdAt ? new Date(report.createdAt).toLocaleDateString('id-ID') : '-',
    "Status": report.status || '-',
    "Desa/Kelurahan": report.village || '-',
    "Detail Lokasi": report.location_details || '-',
    "Latitude": report.latitude || '-',
    "Longitude": report.longitude || '-',
  }));

  const worksheet = XLSX.utils.json_to_sheet(data, {
    header: [
      "Pelapor",
      "Nomor Laporan",
      "Judul Laporan",
      "Deskripsi",
      "Tanggal Dibuat",
      "Status",
      "Desa/Kelurahan",
      "Detail Lokasi",
      "Latitude",
      "Longitude",
    ],
  });

  // ✅ Kolom Width Custom
  worksheet['!cols'] = [
    { wch: 20 },
    { wch: 20 },
    { wch: 30 },
    { wch: 50 }, // Deskripsi lebar
    { wch: 20 },
    { wch: 15 },
    { wch: 20 },
    { wch: 40 },
    { wch: 15 },
    { wch: 15 },
  ];

  // ✅ Style Header
  const range = XLSX.utils.decode_range(worksheet['!ref']);
  for (let C = range.s.c; C <= range.e.c; ++C) {
    const cellAddress = XLSX.utils.encode_cell({ r: 0, c: C });
    if (!worksheet[cellAddress]) continue;
    worksheet[cellAddress].s = {
      font: { bold: true, color: { rgb: "FFFFFF" } },
      fill: { patternType: "solid", fgColor: { rgb: "4CAF50" } }, // Hijau header
      alignment: { horizontal: "center", vertical: "center", wrapText: true },
      border: {
        top: { style: "thin", color: { auto: 1 } },
        right: { style: "thin", color: { auto: 1 } },
        bottom: { style: "thin", color: { auto: 1 } },
        left: { style: "thin", color: { auto: 1 } },
      },
    };
  }

  // ✅ Style Seluruh Data (border + wrapText)
  for (let R = range.s.r + 1; R <= range.e.r; ++R) {
    for (let C = range.s.c; C <= range.e.c; ++C) {
      const cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
      if (!worksheet[cellAddress]) continue;
      worksheet[cellAddress].s = {
        alignment: { vertical: "top", wrapText: true },
        border: {
          top: { style: "thin", color: { auto: 1 } },
          right: { style: "thin", color: { auto: 1 } },
          bottom: { style: "thin", color: { auto: 1 } },
          left: { style: "thin", color: { auto: 1 } },
        },
      };
    }
  }

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Daftar Laporan');

  const excelBuffer = XLSX.write(workbook, {
    bookType: 'xlsx',
    type: 'array',
    cellStyles: true, // ✅ Aktifkan style!
  });

  const blob = new Blob([excelBuffer], { type: 'application/octet-stream' });
  saveAs(blob, `Daftar_Laporan_${new Date().toISOString().slice(0, 10)}.xlsx`);
};
