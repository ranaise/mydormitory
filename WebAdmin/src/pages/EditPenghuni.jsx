import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import API from "../api";

export default function EditPenghuni() {
  const navigate = useNavigate();
  const { id } = useParams(); // Ambil ID penghuni dari URL
  const [formData, setFormData] = useState({
    nama: "",
    nim: "",
    gedung: "",
    nomor_kamar: "",
    nomor_hp: "",
  });

  useEffect(() => {
    const fetchPenghuni = async () => {
      try {
        const response = await API.get(`/penghuni/${id}`); // API untuk detail penghuni
        setFormData(response.data);
      } catch (error) {
        console.error("Error fetching penghuni data:", error);
      }
    };

    fetchPenghuni();
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await API.put(`/penghuni/${id}`, formData); // API untuk update penghuni
      alert("Penghuni berhasil diperbarui!");
      navigate("/penghuni");
    } catch (error) {
      console.error("Error editing penghuni:", error);
    }
  };

  return (
    <div className="page-container">
      <button className="btn-back" onClick={() => navigate("/penghuni")}>
        ⬅ Kembali ke Daftar Penghuni
      </button>

      <h1>Edit Penghuni</h1>
      <p>Perbarui detail penghuni:</p>

      <form className="form-container" onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Nama Penghuni"
          value={formData.nama}
          onChange={(e) => setFormData({ ...formData, nama: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="NIM"
          value={formData.nim}
          onChange={(e) => setFormData({ ...formData, nim: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Gedung"
          value={formData.gedung}
          onChange={(e) => setFormData({ ...formData, gedung: e.target.value })}
          required
        />
        <input
          type="number"
          placeholder="Nomor Kamar"
          value={formData.nomor_kamar}
          onChange={(e) =>
            setFormData({ ...formData, nomor_kamar: e.target.value })
          }
          required
        />
        <input
          type="text"
          placeholder="Nomor HP"
          value={formData.nomor_hp}
          onChange={(e) =>
            setFormData({ ...formData, nomor_hp: e.target.value })
          }
        />
        <button type="submit" className="btn-action">
          ✏️ Perbarui
        </button>
      </form>
    </div>
  );
}