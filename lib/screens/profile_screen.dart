import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart'; 

// Asumsi '../models/book_model.dart' adalah jalur yang benar dan 
// BookModel memiliki struktur 'id', 'title', 'author', 'status', 'image'.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<BookModel> borrowedBooks = [];
  int totalBorrowed = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBorrowedData();
  }

  // ================= FUNGSI NAVIGASI & AUTH ==================

  Future<void> _logout() async {
    // 1. Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Hapus data otentikasi (PENTING untuk Logout)
    // Hapus token atau flag is_logged_in. Anda mungkin perlu menyesuaikan key-nya.
    await prefs.remove('user_token'); 
    await prefs.setBool('isLoggedIn', false);
    
    // 3. Navigasi ke halaman Login dan hapus semua rute sebelumnya
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/Login', // Rute Named ke halaman Login Anda
        (Route<dynamic> route) => false, // Menghapus semua rute sebelumnya
      );
    }
  }

  // 4. Konfirmasi & Reset Data Peminjaman
  Future<void> _confirmResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pengembalian Buku'),
        content: const Text('Apakah Anda yakin ingin mengembalikan semua buku yang dipinjam dan mereset status ketersediaan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _resetBorrowedData();
    }
  }

  // ================= LOAD & RESET DATA (Logika Penyimpanan) ==================

  Future<void> _loadBorrowedData() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Ambil daftar ID buku yang dipinjam
    final String? borrowedJson = prefs.getString('borrowed_books');
    List<int> borrowedIds = [];

    if (borrowedJson != null && borrowedJson.isNotEmpty) {
      try {
        borrowedIds = List<int>.from(json.decode(borrowedJson));
      } catch (e) {
        print('Error decoding borrowed books list: $e');
      }
    }

    // 2. Ambil data buku lengkap
    final String? data = prefs.getString("book_data"); 
    List<BookModel> allBooks = [];

    if (data != null && data.isNotEmpty) {
      try {
        List decoded = jsonDecode(data);
        allBooks = decoded.map((e) => BookModel.fromJson(e)).toList();
      } catch (e) {
        print('FATAL Error decoding book data (book_data): $e');
      }
    }
    
    // 3. Update State
    if (mounted) {
      setState(() {
        totalBorrowed = borrowedIds.length;
        // Filter buku yang sedang dipinjam
        borrowedBooks = allBooks.where((book) => borrowedIds.contains(book.id)).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _resetBorrowedData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    // 1. Hapus daftar ID buku yang dipinjam
    await prefs.remove('borrowed_books');

    final String? allBooksJson = prefs.getString('book_data');

    if (allBooksJson != null && allBooksJson.isNotEmpty) {
      try {
        List<dynamic> decodedList = json.decode(allBooksJson);
        List<Map<String, dynamic>> allBooks = 
          decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
        
        // 2. Ubah status semua buku menjadi 'Available'
        for (var book in allBooks) {
          book['status'] = 'Available';
        }
        
        // 3. Simpan kembali data buku yang sudah di-update
        await prefs.setString('book_data', json.encode(allBooks)); 

      } catch (e) {
        print('Error resetting book status in book_data: $e');
      }
    }
    
    // 4. Muat ulang data untuk update UI
    await _loadBorrowedData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status peminjaman dan ketersediaan buku telah direset!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ================= HELPER WIDGET ==================

  // Widget pengganti jika aset gambar tidak ditemukan
  Widget _imageErrorWidget(double height, {String? text}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.brown.shade200, 
      child: Center(
        child: Text(
          text ?? "Gambar tidak ditemukan",
          style: TextStyle(color: Colors.brown.shade800),
        ),
      ),
    );
  }

  // ================= BUILD UI ==================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ===== BACKGROUND BAWAH (Memakai errorBuilder) =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/background1.png", // Path yang menyebabkan error di aplikasi aslinya
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _imageErrorWidget(280, text: "Background tidak ditemukan");
              },
            ),
          ),

          SafeArea(
            child: SingleChildScrollView( 
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Color(0xFF4E2600),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ), 
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ===== CARD PROFILE =====
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1D6),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // FOTO
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                const CircleAvatar(
                                  radius: 55,
                                  backgroundImage: AssetImage("assets/keris.png"),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4E2600),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Christian Immanuel",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF4E2600),
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "XI RPL 7  |  08",
                              style: TextStyle(color: Colors.brown, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ===== RIWAYAT PEMINJAMAN =====
                    const Text(
                      "Riwayat Peminjaman",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    Text(
                      borrowedBooks.isEmpty 
                        ? "Belum ada buku yang kamu pinjam. Coba pinjam satu!"
                        : "Berikut adalah riwayat buku yang sedang kamu pinjam.",
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 100,
                      child: borrowedBooks.isEmpty
                        ? const Center(child: Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 40))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: borrowedBooks.length,
                            itemBuilder: (context, index) {
                              final book = borrowedBooks[index];

                              return Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(8),
                                width: 220,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1D6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        book.image ?? "assets/images/book.jpg",
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors.grey.shade400,
                                            child: const Icon(
                                              Icons.book_outlined,
                                              size: 30,
                                              color: Colors.black54,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            book.author,
                                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                                          ),
                                          Text(
                                            "Status: ${book.status ?? 'N/A'}",
                                            style: TextStyle(fontSize: 10, color: book.status == 'Available' ? Colors.green : Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    ),

                    const SizedBox(height: 15),

                    // ===== TOTAL BUKU =====
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1D6),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Buku yang dipinjam :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "$totalBorrowed",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ===== TOMBOL RESET PEMINJAMAN (Kembalikan Buku) =====
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _confirmResetData, // Memanggil fungsi konfirmasi
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text(
                          "Kembalikan Buku",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 237, 185, 127),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15), 

                    // ===== TOMBOL LOGOUT BARU =====
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _logout, // Panggil fungsi logout
                        icon: const Icon(Icons.exit_to_app, color: Colors.white),
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700, 
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}