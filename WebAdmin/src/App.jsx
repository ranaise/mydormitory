import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Presensi from "./pages/Presensi";
import LaporanMasalah from "./pages/LaporanMasalah";
import Penghuni from "./pages/Penghuni";
import AddPenghuni from "./pages/AddPenghuni";
import EditPenghuni from "./pages/EditPenghuni";
import LaporanPresensi from "./pages/LaporanPresensi";

const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem("token"); // Periksa token autentikasi di localStorage
  return token ? children : <Navigate to="/login" replace />;
};

export default function App() {
  return (
    <Router>
      <Routes>
        {/* Halaman Login */}
        <Route path="/login" element={<Login />} />

        {/* Halaman Dilindungi (Dashboard dan sub-halaman lainnya) */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />

        <Route
          path="/presensi"
          element={
            <ProtectedRoute>
              <Presensi />
            </ProtectedRoute>
          }
        />

        <Route
          path="/laporan"
          element={
            <ProtectedRoute>
              <LaporanMasalah />
            </ProtectedRoute>
          }
        />

        <Route
          path="/penghuni"
          element={
            <ProtectedRoute>
              <Penghuni />
            </ProtectedRoute>
          }
        />

        <Route
          path="/penghuni/add"
          element={
            <ProtectedRoute>
              <AddPenghuni />
            </ProtectedRoute>
          }
        />
        
        <Route
          path="/penghuni/edit/:id"
          element={
            <ProtectedRoute>
              <EditPenghuni />
            </ProtectedRoute>
          }
        />

        <Route
          path="/laporan-presensi"
          element={
            <ProtectedRoute>
              <LaporanPresensi />
            </ProtectedRoute>
          }
        />

        {/* Default Redirect ke /login */}
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </Router>
  );
}