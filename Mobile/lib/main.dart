import 'package:mydormitory/screens/login_screen.dart'; // Sesuaikan path folder kamu
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            // ignore: deprecated_member_use
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
      theme: ThemeData(
        primaryColor: const Color(0xFFB01015),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB01015)),
      ),
      home: const LoginScreen(),
    );
  }
}
