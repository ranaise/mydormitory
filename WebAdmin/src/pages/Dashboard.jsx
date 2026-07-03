import React from "react";
import { useNavigate } from "react-router-dom";

export default function Dashboard() {
  const navigate = useNavigate();

  // Fungsi logout
  const handleLogout = () => {
    localStorage.removeItem("token"); // Hapus token dari localStorage
    localStorage.removeItem("user_id"); // Hapus user_id jika ada
    alert("Anda telah logout.");
    navigate("/login"); // Redirect ke halaman login
  };

  return (
    <div className="dashboard-container">
      <button className="btn-logout" onClick={handleLogout}>
        Logout
      </button>

      <h1>Dashboard Admin</h1>
      <p>Selamat datang di panel admin. Pilih fitur yang ingin diakses:</p>

      <div className="dashboard-links">
        <a href="/presensi" className="dashboard-link">
          <div className="link-card">
            <h2>Presensi</h2>
            <p>Lihat & verifikasi presensi penghuni.</p>
          </div>
        </a>

        <a href="/penghuni" className="dashboard-link">
          <div className="link-card">
            <h2>Kelola Penghuni</h2>
            <p>Kelola data penghuni (Tambah, Edit, dan Hapus).</p>
          </div>
        </a>

        <a href="/laporan" className="dashboard-link">
          <div className="link-card">
            <h2>Laporan Masalah</h2>
            <p>Kelola laporan masalah dari penghuni.</p>
          </div>
        </a>

        <a href="/laporan-presensi" className="dashboard-link">
          <div className="link-card">
            <h2>Laporan Presensi</h2>
            <p>Download laporan presensi penghuni.</p>
          </div>
        </a>
      </div>
    </div>
  );
}