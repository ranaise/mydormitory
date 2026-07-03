import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../api";

export default function AddPenghuni() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    nama: "",
    nim: "",
    angkatan: "",
    gedung: "",
    nomor_kamar: "",
    nomor_hp: "",
    email: "",
    password: "",
    // qr_data: "", // optional kalau mau input manual
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Validasi sederhana (opsi A: tidak butuh user_id)
    if (
      !formData.nama ||
      !formData.nim ||
      !formData.angkatan ||
      !formData.gedung ||
      !formData.nomor_kamar ||
      !formData.email ||
      !formData.password
    ) {
      alert("Harap isi semua bidang yang wajib (*)");
      return;
    }

    setLoading(true);

    try {
      // Pastikan endpoint-nya sesuai routes backend kamu:
      // kalau di Laravel route-nya /api/penghunis -> pakai "/penghunis"
      const response = await API.post("/penghuni", {
        ...formData,
        nomor_kamar: Number(formData.nomor_kamar),
      });

      console.log("API Response:", response.data);
      alert("Penghuni berhasil ditambahkan!");
      navigate("/penghuni");
    } catch (error) {
      console.error("Error adding penghuni:", error.response ? error.response.data : error);
      alert(
        `Gagal menambahkan penghuni: ${
          error.response?.data?.message || "Mohon cek data dan jaringan Anda."
        }`
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-container">
      <button className="btn-back" onClick={() => navigate("/penghuni")}>
        ⬅ Kembali ke Daftar Penghuni
      </button>

      <h1>Tambah Penghuni</h1>
      <p>Masukkan detail penghuni baru:</p>

      <form className="form-container" onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Nama Penghuni *"
          value={formData.nama}
          onChange={(e) => setFormData({ ...formData, nama: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="NIM *"
          value={formData.nim}
          onChange={(e) => setFormData({ ...formData, nim: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Angkatan * (contoh: 2023)"
          value={formData.angkatan}
          onChange={(e) => setFormData({ ...formData, angkatan: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Gedung *"
          value={formData.gedung}
          onChange={(e) => setFormData({ ...formData, gedung: e.target.value })}
          required
        />
        <input
          type="number"
          placeholder="Nomor Kamar *"
          value={formData.nomor_kamar}
          onChange={(e) => setFormData({ ...formData, nomor_kamar: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Nomor HP"
          value={formData.nomor_hp}
          onChange={(e) => setFormData({ ...formData, nomor_hp: e.target.value })}
        />

        <hr />
        <h3 style={{ marginTop: 16 }}>Buat Akun Penghuni</h3>
        <p style={{ marginBottom: 8, color: "#666" }}>
        Email & password ini dipakai penghuni untuk login di aplikasi mobile.
        </p>

        <input
        type="email"
        placeholder="Email Akun Penghuni *"
        value={formData.email}
        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        required
        />

        <input
        type="password"
        placeholder="Password Akun Penghuni *"
        value={formData.password}
        onChange={(e) => setFormData({ ...formData, password: e.target.value })}
        required
        />


        <button type="submit" className="btn-action" disabled={loading}>
          {loading ? "Loading..." : "➕ Tambah"}
        </button>
      </form>
    </div>
  );
}
