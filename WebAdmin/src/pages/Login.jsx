import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../api";

export default function Login() {
  const [email, setEmail] = useState(""); // State untuk email
  const [password, setPassword] = useState(""); // State untuk password
  const [error, setError] = useState(null); // State untuk pesan error
  const navigate = useNavigate(); // Hook untuk navigasi

  // Fungsi untuk menangani submit form
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await API.post("/login", { email, password });
      if (response.data.success) {
        localStorage.setItem("token", response.data.token); // Simpan token
        navigate("/dashboard"); // Redirect ke dashboard
      } else {
        setError("Email atau password salah");
      }
    } catch (err) {
      setError("Gagal login. Cek koneksi atau server.");
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-logo">
          <img src="https://yt3.googleusercontent.com/ytc/AIdro_k0osXMkEStPYzWQlnxtxyHiMrXN9SYd007lvHfdE2w8ls=s900-c-k-c0x00ffffff-no-rj" alt="Logo" />
        </div>
        <h1>Login Admin</h1>
        {error && <p className="error-message">{error}</p>}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="email">Email:</label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Masukkan email"
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password:</label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Masukkan password"
              required
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Login
          </button>
        </form>

        <div className="credentials">
          <h5>Demo Credentials:</h5>
          <ul>
            <li>Email: <strong>admin@test.com</strong></li>
            <li>Password: <strong>password</strong></li>
          </ul>
        </div>
      </div>
    </div>
  );
}