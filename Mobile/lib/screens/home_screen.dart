import 'package:flutter/material.dart';
import '../models/user.dart'; // Pastikan path ini sesuai dengan struktur foldermu
import '../models/penghuni.dart';
import '../services/api_service.dart';
import 'attendance_history_screen.dart';
import 'report_issue_screen.dart';
import 'notifications_screen.dart';
import 'scan_qr_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final Penghuni penghuni;

  const HomeScreen({super.key, required this.user, required this.penghuni});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel State untuk menampung data dari Database nanti
  bool _isLoading = false;
  bool _hasAttended = false; // Status absensi hari ini

  @override
  void initState() {
    super.initState();
    // Saat halaman dibuka, otomatis "Bertanya" ke Backend
    _checkAttendanceStatus();
  }

  Future<void> _checkAttendanceStatus() async {
    setState(() => _isLoading = true);
    final attended = await ApiService.hasPresensiToday(widget.penghuni.id);
    if (!mounted) return;
    setState(() {
      _hasAttended = attended;
      _isLoading = false;
    });
  }

  Future<void> _handleScanQR() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ScanQrScreen(penghuni: widget.penghuni),
      ),
    );

    if (result == true) {
      setState(() => _hasAttended = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil inisial nama untuk avatar (unused variable removed)

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Background abu sangat muda
      body: Stack(
        children: [
          // ---------------------------------------------
          // BAGIAN 1: HEADER BIRU (Background Design)
          // ---------------------------------------------
          Container(
            height: 280,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFB01015), // Primary merah sesuai CSS
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.8 * 255).round()),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user.name, // Data Dinamis dari Model
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Karena model belum ada 'room', kita pakai placeholder atau email
                        Row(
                          children: [
                            const Icon(
                              Icons.meeting_room,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Room A-205", // Nanti ganti: widget.user.room
                              style: TextStyle(
                                color: Colors.white.withAlpha(
                                  (0.9 * 255).round(),
                                ),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Tombol Logout Kecil di pojok
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------------------------------------
          // BAGIAN 2: KONTEN UTAMA (Layer Atas)
          // ---------------------------------------------
          Padding(
            padding: const EdgeInsets.only(top: 180, left: 24, right: 24),
            child: Column(
              children: [
                // --- KARTU ATTENDANCE (CORE FEATURE) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFB01015,
                        ).withAlpha((0.15 * 255).round()),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Attendance Status Today",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          _hasAttended
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: _hasAttended
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _hasAttended ? "Present" : "Not Yet",
                                          style: TextStyle(
                                            color: _hasAttended
                                                ? Colors.green
                                                : Colors.orange,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.qr_code_2,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _hasAttended
                              ? null
                              : _handleScanQR, // Disable jika sudah absen
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB01015),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Scan QR Attendance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- MENU LIST ---
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuItem(
                        icon: Icons.history,
                        color: Colors.blue,
                        title: "Attendance History",
                        subtitle: "View your past records",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AttendanceHistoryScreen(
                                penghuni: widget.penghuni,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.report_problem_rounded,
                        color: Colors.orange,
                        title: "Report Issue",
                        subtitle: "Correct your attendance",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReportIssueScreen(penghuni: widget.penghuni),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_active_rounded,
                        color: Colors.purple,
                        title: "Notifications",
                        subtitle: "Announcements from dorm",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NotificationsScreen(user: widget.user),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha((0.1 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
