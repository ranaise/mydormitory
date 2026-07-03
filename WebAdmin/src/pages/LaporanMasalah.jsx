import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import API from "../api"; // Axios instance untuk API call

export default function LaporanMasalah() {
  const navigate = useNavigate();
  const [laporan, setLaporan] = useState([]); // State untuk daftar laporan
  const [loading, setLoading] = useState(false); // Loading state

  // Fetch data laporan dari API saat halaman dimuat
  useEffect(() => {
    const fetchLaporan = async () => {
      setLoading(true);
      try {
        const response = await API.get("/laporan"); // Sesuaikan endpoint dengan backend
        setLaporan(response.data || []);
      } catch (error) {
        console.error("Error fetching laporan:", error.response || error);
      } finally {
        setLoading(false);
      }
    };

    fetchLaporan();
  }, []);

  // Fungsi untuk update status laporan menjadi "Diproses" atau "Selesai"
  const handleUpdateStatus = async (id, status) => {
    try {
      const response = await API.put(`/laporan/${id}`, { status }); // Sesuaikan endpoint backend
      alert(`Laporan berhasil diperbarui ke status: ${status}`);
      setLaporan((prev) =>
        prev.map((item) =>
          item.id === id ? { ...item, status: response.data.status } : item
        )
      );
    } catch (error) {
      console.error("Error updating status:", error.response || error);
      alert("Gagal memperbarui status laporan. Silakan coba lagi.");
    }
  };

  return (
    <div className="page-container">
      <button className="btn-back" onClick={() => navigate("/dashboard")}>
        ⬅ Kembali ke Dashboard
      </button>

      <h1>Laporan Masalah</h1>
      <p>Di sini Anda dapat melihat dan memproses laporan masalah penghuni.</p>

      {loading ? (
        <p>Memuat data...</p>
      ) : laporan.length > 0 ? (
        <div className="grid-container">
          {laporan.map((item) => (
            <div className="grid-item" key={item.id}>
              <h2>{item.judul}</h2>
              <p>Deskripsi: {item.deskripsi}</p>
              <p>Status: <strong>{item.status}</strong></p>
              <button
                className="btn-action"
                onClick={() => handleUpdateStatus(item.id, "Diproses")}
              >
                Tandai Diproses
              </button>
              <button
                className="btn-action"
                onClick={() => handleUpdateStatus(item.id, "Selesai")}
              >
                Tandai Selesai
              </button>
            </div>
          ))}
        </div>
      ) : (
        <p>Tidak ada laporan tersedia.</p>
      )}
    </div>
  );
}