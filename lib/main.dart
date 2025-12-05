import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/linimasa_screen.dart';
import 'screens/profile_screen.dart'; // Pastikan ProfileScreen juga di-import jika digunakan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah user sudah login
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  

  const MyApp({super.key, required this.isLoggedIn});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Library',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Poppins',
      ),

      debugShowCheckedModeBanner: false,

      // Route untuk navigasi
      routes: {
        '/Login': (context) => const LoginScreen(),
        '/Main': (context) => const MainScreen(),
        '/Home': (context) => const HomeScreen(),
        '/Linimasa': (context) => const LinimasaScreen(),
        '/splash': (context) => SplashScreen(isLoggedIn: isLoggedIn),
      },

      // Halaman awal = SplashScreen, tapi SplashScreen akan membaca isLoggedIn
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );
  }
}