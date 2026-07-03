import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:mydormitory/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String _message = '';

  void _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    debugPrint("=== DEBUG DATA LOGIN ===");
    debugPrint("Email dikirim: '$email'"); // Perhatikan tanda kutipnya
    debugPrint(
      "Password dikirim: '$password'",
    ); // Apakah ada spasi di dalam kutip?
    debugPrint("========================");

    try {
      final response = await ApiService.login(email, password).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
            "Koneksi Timeout! Server tidak merespon dalam 15 detik.",
          );
        },
      );

      if (mounted) {
        setState(() {
          _loading = false;

          if (response.success && response.user != null) {
            if (response.role != 'penghuni' || response.penghuni == null) {
              _message = 'Akun ini bukan penghuni (khusus mobile penghuni).';
              return;
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: response.user!,
                  penghuni: response.penghuni!,
                ),
              ),
            );
          } else {
            _message = response.message ?? 'Login gagal';
          }
        });
      }
    } catch (e) {
      debugPrint("ERROR LOGIN: $e"); // Cek terminal

      if (mounted) {
        setState(() {
          _loading = false;
          _message = 'Gagal terhubung: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo circle
              CircleAvatar(
                radius: 44,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.home_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Login Penghuni Asrama',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Card with form
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 520),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.06 * 255).round()),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Gunakan Akun SSO untuk Login',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'youremail@dorm.edu',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Masukkan email' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Masukkan password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Masukkan password' : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _doLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_message.isNotEmpty)
                        Text(
                          _message,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
