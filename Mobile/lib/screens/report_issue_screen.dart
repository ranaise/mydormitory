import 'package:flutter/material.dart';
import '../models/penghuni.dart';
import '../services/api_service.dart';

class ReportIssueScreen extends StatefulWidget {
  final Penghuni penghuni;
  const ReportIssueScreen({super.key, required this.penghuni});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final tipe = TextEditingController();
  final desk = TextEditingController();
  bool loading = false;

  Future<void> submit() async {
    if (tipe.text.trim().isEmpty || desk.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipe masalah & deskripsi wajib diisi')),
      );
      return;
    }

    setState(() => loading = true);
    final res = await ApiService.createLaporanMasalah(
      penghuniId: widget.penghuni.id,
      tipeMasalah: tipe.text.trim(),
      deskripsi: desk.text.trim(),
    );
    setState(() => loading = false);

    final code = res['statusCode'] as int;
    final body = res['body'] as Map<String, dynamic>;

    if (!mounted) return;

    if ((code == 200 || code == 201) && body.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Laporan berhasil dikirim')));
      tipe.clear();
      desk.clear();
    } else {
      final msg = body['message']?.toString() ?? 'Gagal kirim laporan ($code)';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(title: const Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: tipe,
                    decoration: const InputDecoration(
                      labelText: 'Tipe Masalah',
                      hintText: 'contoh: Kebersihan / Kerusakan / Keamanan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: desk,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Jelaskan masalah secara detail',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB01015),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(loading ? 'Mengirim...' : 'Kirim Laporan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
