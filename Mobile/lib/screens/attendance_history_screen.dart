import 'package:flutter/material.dart';
import '../models/penghuni.dart';
import '../services/api_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final Penghuni penghuni;
  const AttendanceHistoryScreen({super.key, required this.penghuni});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  bool loading = true;
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    final list = await ApiService.getRiwayatPresensi(widget.penghuni.id);
    if (!mounted) return;
    setState(() {
      items = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(title: const Text('Attendance History')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: items.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 220),
                        Center(child: Text('Belum ada riwayat presensi')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final it = items[i] as Map<String, dynamic>;
                        final waktu = (it['waktu_presensi'] ?? '-').toString();
                        final verif =
                            (it['status_verifikasi'] ?? 'Belum Diverifikasi')
                                .toString();
                        final catatan = (it['catatan_admin'] ?? '').toString();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                waktu,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('Verifikasi: $verif'),
                              if (catatan.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text('Catatan: $catatan'),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
