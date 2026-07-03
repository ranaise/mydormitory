import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function LaporanPresensi() {
  const navigate = useNavigate();
  const [presensi, setPresensi] = useState([
    {
      nama_penghuni: "Nai",
      waktu_presensi: "2025-12-29 08:00:00",
      status_verifikasi: "Terverifikasi",
    },
    {
      nama_penghuni: "Rael",
      waktu_presensi: "2025-12-30 09:00:00",
      status_verifikasi: "Belum Terverifikasi",
    },
    {
      nama_penghuni: "Tisee",
      waktu_presensi: "2025-12-31 10:30:00",
      status_verifikasi: "Terverifikasi",
    },
  ]); // Dummy data sebagai gantinya jika tidak ada API
  const [error, setError] = useState(null);

  // Fungsi untuk generate dan download CSV
  const handleExportCSV = () => {
    const rows = presensi.map((p) => ({
      nama_penghuni: p.nama_penghuni,
      waktu_presensi: p.waktu_presensi,
      status_verifikasi: p.status_verifikasi,
    }));

    const csvContent =
      "data:text/csv;charset=utf-8," +
      ["Nama Penghuni, Waktu Presensi, Status Verifikasi"]
        .concat(rows.map((row) => `${row.nama_penghuni},${row.waktu_presensi},${row.status_verifikasi}`))
        .join("\n");

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "laporan_presensi.csv");
    document.body.appendChild(link);
    link.click();
  };

  return (
    <div className="laporan-presensi-container">
      <button className="btn-back" onClick={() => navigate("/dashboard")}>
        ⬅ Kembali ke Dashboard
      </button>

      <h1>Laporan Presensi</h1>
      {error && <p className="error-message">{error}</p>}

      <table className="table">
        <thead>
          <tr>
            <th>Nama Penghuni</th>
            <th>Waktu Presensi</th>
            <th>Status Verifikasi</th>
          </tr>
        </thead>
        <tbody>
          {presensi.map((item, index) => (
            <tr key={index}>
              <td>{item.nama_penghuni}</td>
              <td>{item.waktu_presensi}</td>
              <td>{item.status_verifikasi}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <button className="btn-action" onClick={handleExportCSV}>
        Download CSV
      </button>
    </div>
  );
}