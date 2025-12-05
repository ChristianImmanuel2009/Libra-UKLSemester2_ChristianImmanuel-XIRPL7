import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color _darkBrown = Color(0xFF2D1600);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  // State baru untuk mengontrol visibilitas password
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    // Periksa validasi formulir
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi loading login
    // Di sini Anda akan menambahkan logika otentikasi nyata
    await Future.delayed(const Duration(seconds: 1));

    // Simpan status login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;

    // Navigasi ke MainScreen setelah login berhasil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        color: _darkBrown, // Mengubah warna ikon default
                      );
                    },
                  ),
                ),

                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _darkBrown,
                  ),
                ),

                const SizedBox(height: 30),

                // USERNAME
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  // Menggunakan _isPasswordVisible untuk mengontrol teks tersembunyi
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    // Menambahkan IconButton sebagai suffixIcon
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Pilih ikon yang sesuai berdasarkan _isPasswordVisible
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Mengubah state untuk mengganti visibilitas
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    // Perbaikan: Pastikan pemeriksaan panjang password benar
                    if (value == null || value.isEmpty) {
                       return "Password minimal 4 karakter";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 237, 185, 127),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: _darkBrown), // Mengubah warna teks tombol
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}