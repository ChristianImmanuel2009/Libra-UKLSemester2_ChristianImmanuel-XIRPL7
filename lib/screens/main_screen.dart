// lib/screens/main_screen.dart

import 'package:aplikasi_kopi/screens/linimasa_screen.dart';
import 'package:aplikasi_kopi/screens/login_screen.dart';
import 'package:aplikasi_kopi/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
// import file lain untuk Linimasa dan Profil

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Index 1 = Home (sesuai gambar Anda)

  final List<Widget> _screens = [
    // Tambahkan layar lain (Linimasa/Timeline)
    const LinimasaScreen(), // Index 0
    const HomeScreen(), // Index 1
    const ProfileScreen(), // Index 2
    const LoginScreen(), // Index 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Linimasa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Sesuaikan warna
        unselectedItemColor: Colors.grey, // Sesuaikan warna
        onTap: _onItemTapped,
      ),
    );
  }
}