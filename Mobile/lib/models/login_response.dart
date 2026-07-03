import 'user.dart';
import 'penghuni.dart';

class LoginResponse {
  final bool success;
  final String? role;
  final User? user;
  final Penghuni? penghuni;
  final String? message;

  LoginResponse({
    required this.success,
    this.role,
    this.user,
    this.penghuni,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      role: json['role']?.toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      penghuni: json['penghuni'] != null
          ? Penghuni.fromJson(json['penghuni'])
          : null,
      message: json['message']?.toString(),
    );
  }
}
