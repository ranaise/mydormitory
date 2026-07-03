import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mydormitory/models/login_response.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.156.141:8000/api'; // ip local

  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    Map<String, dynamic>? data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      data = null;
    }

    if (kDebugMode) {
      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');
    }

    if (response.statusCode == 200 && data != null) {
      return LoginResponse.fromJson(data);
    }

    return LoginResponse(
      success: false,
      message: data != null && data['message'] != null
          ? data['message'].toString()
          : 'Server error (${response.statusCode})',
    );
  }

  // ===== PRESENSI =====
  static Future<Map<String, dynamic>> createPresensi({
    required int penghuniId,
    required String qrCode,
    double? lat,
    double? lng,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/presensi'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'penghuni_id': penghuniId,
        'qr_code': qrCode,
        'lokasi_lat': lat,
        'lokasi_lng': lng,
      }),
    );

    Map<String, dynamic> body = {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } catch (_) {}

    return {'statusCode': response.statusCode, 'body': body};
  }

  static Future<List<dynamic>> getRiwayatPresensi(int penghuniId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/presensi/riwayat/$penghuniId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
    }
    return [];
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static Future<bool> hasPresensiToday(int penghuniId) async {
    final list = await getRiwayatPresensi(penghuniId);
    final now = DateTime.now();
    for (final item in list) {
      final waktu = item['waktu_presensi'];
      if (waktu != null) {
        final dt = DateTime.tryParse(waktu.toString());
        if (dt != null && _isSameDay(dt, now)) return true;
      }
    }
    return false;
  }

  // ===== LAPORAN MASALAH =====
  static Future<Map<String, dynamic>> createLaporanMasalah({
    required int penghuniId,
    required String tipeMasalah,
    required String deskripsi,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/laporan'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'penghuni_id': penghuniId,
        'tipe_masalah': tipeMasalah,
        'deskripsi': deskripsi,
      }),
    );

    Map<String, dynamic> body = {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } catch (_) {}

    return {'statusCode': response.statusCode, 'body': body};
  }

  // ===== NOTIFIKASI =====
  static Future<List<dynamic>> getNotifikasi(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifikasi/$userId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
    }
    return [];
  }
}
