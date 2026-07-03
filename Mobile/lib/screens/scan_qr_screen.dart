import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import '../models/penghuni.dart';

class ScanQrScreen extends StatefulWidget {
  final Penghuni penghuni;
  const ScanQrScreen({super.key, required this.penghuni});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool scanned = false;

  Future<void> handleScan(String qr) async {
    if (scanned) return;
    scanned = true;

    final res = await ApiService.createPresensi(
      penghuniId: widget.penghuni.id,
      qrCode: qr,
    );

    final code = res['statusCode'] as int;
    final body = res['body'] as Map<String, dynamic>;

    if (!mounted) return;

    if (code == 201 && body['success'] == true) {
      Navigator.pop(context, true); // sukses
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Presensi berhasil')));
    } else {
      final msg = body['message']?.toString() ?? 'Gagal presensi';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Presensi')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final value = barcode.rawValue;
          if (value != null) {
            handleScan(value);
          }
        },
      ),
    );
  }
}
