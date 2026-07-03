import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../api";

export default function Penghuni() {
  const navigate = useNavigate();

  // State untuk daftar penghuni
  const [penghuni, setPenghuni] = useState([]);

  // Load data penghuni (Mock fetch data API)
  React.useEffect(() => {
    const fetchPenghuni = async () => {
      try {
        const response = await API.get("/penghuni"); // Ganti dengan API sesungguhnya
        setPenghuni(response.data || []);
      } catch (error) {
        console.error("Error fetching penghuni data:", error);
      }
    };

    fetchPenghuni();
  }, []);

  const handleDelete = async (id) => {
    if (!window.confirm("Apakah Anda yakin ingin menghapus penghuni ini?")) {
      return; // Konfirmasi sebelum hapus
    }

    try {
      await API.delete(`/penghuni/${id}`); // Endpoint hapus penghuni berdasarkan ID
      alert("Penghuni berhasil dihapus!");
      setPenghuni((prev) => prev.filter((item) => item.id !== id)); // Update data penghuni di UI
    } catch (error) {
      console.error("Error deleting penghuni:", error.response || error);
      alert("Gagal menghapus penghuni. Silakan coba lagi.");
    }
  };

  return (
    <div className="page-container">
      <button className="btn-back" onClick={() => navigate("/dashboard")}>
        ⬅ Kembali ke Dashboard
      </button>

      <h1>Kelola Penghuni</h1>
      <p>Di sini Anda dapat melihat, menambahkan, dan mengedit data penghuni.</p>

      {/* Tombol tambah penghuni */}
      <button
        className="btn-action"
        onClick={() => navigate("/penghuni/add")} // Rute untuk tambah penghuni
      >
        ➕ Tambah Penghuni
      </button>

      {/* Daftar penghuni */}
      <div className="grid-container">
        {penghuni.length > 0 ? (
          penghuni.map((item) => (
            <div className="grid-item" key={item.id}>
              <h2>{item.nama}</h2>
              <p>NIM: {item.nim}</p>
              <p>Gedung: {item.gedung}</p>
              <p>Kamar: {item.nomor_kamar}</p>
              {/* Tombol edit */}
              <button
                className="btn-action"
                onClick={() => navigate(`/penghuni/edit/${item.id}`)} // Rute untuk edit penghuni
              >
                ✏️ Edit
              </button>

              <button
                    className="btn-action btn-delete"
                    onClick={() => handleDelete(item.id)}
                  >
                    Hapus
                  </button>
            </div>
          ))
        ) : (
          <p>Penghuni belum tersedia.</p>
        )}
      </div>
    </div>
  );
}