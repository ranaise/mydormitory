class Penghuni {
  final int id;
  final int userId;
  final String nama;
  final String? nim;
  final String? angkatan;
  final String? gedung;
  final int? nomorKamar;
  final String? nomorHp;
  final String? qrData;
  final String? status;

  Penghuni({
    required this.id,
    required this.userId,
    required this.nama,
    this.nim,
    this.angkatan,
    this.gedung,
    this.nomorKamar,
    this.nomorHp,
    this.qrData,
    this.status,
  });

  factory Penghuni.fromJson(Map<String, dynamic> json) {
    int? kamar;
    final nk = json['nomor_kamar'];
    if (nk is int) kamar = nk;
    if (nk is String) kamar = int.tryParse(nk);

    return Penghuni(
      id: json['id'],
      userId: json['user_id'],
      nama: (json['nama'] ?? '').toString(),
      nim: json['nim']?.toString(),
      angkatan: json['angkatan']?.toString(),
      gedung: json['gedung']?.toString(),
      nomorKamar: kamar,
      nomorHp: json['nomor_hp']?.toString(),
      qrData: json['qr_data']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
