import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:8000/api', // Ganti IP jika diubah
});

API.interceptors.request.use((config) => {
  const token = localStorage.getItem('token'); // Ambil token login
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default API;