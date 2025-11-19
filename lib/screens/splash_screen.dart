import 'package:flutter/material.dart';
import 'home_screen.dart'; // Pastikan path ke HomeScreen benar

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke HomeScreen setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body Stack untuk menempatkan latar belakang dan logo di atasnya
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Latar Belakang (sesuai image_be9f42.jpg)
          Image.asset(
            // Ganti path ini sesuai dengan lokasi file Anda
            'assets/backgroundHome1.jpg',
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              // Fallback jika gambar aset tidak ditemukan
              return Container(color: Colors.brown[200]);
            },
          ),

          // 2. Overlay Hitam Transparan (Opsional: untuk membuat logo lebih menonjol)
          Container(
            color: Colors.black.withOpacity(0.05),
          ),

          // 3. Konten (Logo Biji Kopi)
          Center(
            child: SizedBox(
              width: 80, 
              height: 80,
              child: Image.asset(
                // Ganti path ini sesuai dengan lokasi file logo biji kopi Anda
                'assets/IconSPlash.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                   // Fallback jika logo aset tidak ditemukan, kembali ke ikon kopi standar
                  return const Icon(
                    Icons.coffee, 
                    size: 30, 
                    color: Colors.white
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}