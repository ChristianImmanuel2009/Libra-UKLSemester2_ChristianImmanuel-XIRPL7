import 'dart:async';
import 'package:aplikasi_kopi/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required bool isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _startTimerAndNavigate();
  }

  void _startTimerAndNavigate() {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[900],
      body: Stack(
        fit: StackFit.expand,
        children: [

          // Background image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.brown[900]);
            },
          ),

          // Overlay
          Container(
            color: Colors.black.withOpacity(0.2),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo
                SizedBox(
                  width: 130,
                  height: 130,
                  child: Image.asset(
                    'assets/icom.png', // pastikan nama ini sama di pubspec.yaml
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.book_outlined,
                        size: 80,
                        color: Colors.white,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Toko Buku-Ku",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 40),

                CircularProgressIndicator(
                  color: Colors.brown[200],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
