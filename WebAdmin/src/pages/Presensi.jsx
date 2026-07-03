import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function Presensi() {
  const navigate = useNavigate();

  // Dummy data penghuni untuk presensi
  const dummyData = [
    { id: 1, nama: "Rael", gedung: "F", nomor_kamar: "11", status: "Belum Hadir" },
    { id: 2, nama: "Nai", gedung: "A", nomor_kamar: "20", status: "Belum Hadir" },
    { id: 3, nama: "Tisee", gedung: "C", nomor_kamar: "22", status: "Belum Hadir" },
  ];

  const [dataPresensi, setDataPresensi] = useState(dummyData);

  // Mengubah status penghuni menjadi "Hadir"
  const handlePresensi = (id) => {
    setDataPresensi((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, status: "Hadir" } : item
      )
    );
    alert("Presensi berhasil dilakukan.");
  };

  return (
    <div className="page-container">
      <button className="btn-back" onClick={() => navigate("/dashboard")}>
        ⬅ Kembali ke Dashboard
      </button>

      <h1>Presensi Penghuni</h1>
      <p>Lakukan presensi penghuni gedung sesuai daftar:</p>

      {dataPresensi.length > 0 ? (
        <table className="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nama</th>
              <th>Gedung</th>
              <th>Nomor Kamar</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {dataPresensi.map((item) => (
              <tr key={item.id}>
                <td>{item.id}</td>
                <td>{item.nama}</td>
                <td>{item.gedung}</td>
                <td>{item.nomor_kamar}</td>
                <td>{item.status}</td>
                <td>
                  <button
                    className="btn-action"
                    onClick={() => handlePresensi(item.id)}
                    disabled={item.status === "Hadir"}
                  >
                    Presensi
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>Tidak ada data penghuni untuk presensi.</p>
      )}
    </div>
  );
}