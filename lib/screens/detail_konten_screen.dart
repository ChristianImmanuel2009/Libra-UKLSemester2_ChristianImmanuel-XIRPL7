import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKontenScreen extends StatefulWidget {
  final int bookId;

  const DetailKontenScreen({super.key, required this.bookId});

  @override
  State<DetailKontenScreen> createState() => _DetailKontenScreenState();
}

class _DetailKontenScreenState extends State<DetailKontenScreen> {
  static const Color _darkBrown = Color(0xFF2D1600);

  Map<String, dynamic>? _bookData;
  bool _isLoading = true;
  bool _isBorrowed = false; 

  @override
  void initState() {
    super.initState();
    // Panggil _loadBookData, lalu cek status pinjaman
    _loadBookData().then((_) {
      if (_bookData != null) {
        _checkIfBorrowed();
      }
    });
  }

  // ================= LOAD DATA & CHECK STATUS ==================
  
  Future<void> _loadBookData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('book_data');

    if (jsonString == null || jsonString.isEmpty) {
      _setErrorState();
      return;
    }

    try {
      final List decodedList = json.decode(jsonString);

      final List<Map<String, dynamic>> bookList =
          decodedList.map((e) => Map<String, dynamic>.from(e)).toList();

      final Map<String, dynamic>? book = bookList.firstWhere(
        (item) => item['id'] == widget.bookId,
        orElse: () => {},
      );

      if (mounted) {
        setState(() {
          _bookData = book!.isNotEmpty ? book : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      _setErrorState();
    }
  }

  void _setErrorState() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _bookData = null;
      });
    }
  }

  Future<void> _checkIfBorrowed() async {
    final prefs = await SharedPreferences.getInstance();
    final String? borrowedJson = prefs.getString('borrowed_books');
    List<int> borrowedIds = [];

    if (borrowedJson != null && borrowedJson.isNotEmpty) {
      try {
        borrowedIds = List<int>.from(json.decode(borrowedJson));
      } catch (e) {
        print('Error decoding borrowed books: $e');
      }
    }

    final bool borrowed = borrowedIds.contains(widget.bookId);

    if (mounted) {
      setState(() {
        _isBorrowed = borrowed;
        
        // Memastikan status ditampilkan sesuai dengan status pinjaman global
        if (_bookData != null && borrowed) {
             _bookData!['status'] = 'Dipinjam';
        }
      });
    }
  }

  // -> MODIFIKASI: Fungsi untuk menyimpan ID buku dan mengubah status di data utama
  Future<void> _pinjamBuku() async {
    // Cek apakah data buku ada dan belum dipinjam
    if (_bookData == null || _isBorrowed) return;

    final prefs = await SharedPreferences.getInstance();
    
    // =========================================================
    // 1. UPDATE DAFTAR BUKU DIPINJAM ('borrowed_books')
    // =========================================================
    final String? borrowedJson = prefs.getString('borrowed_books');
    List<int> borrowedIds = [];

    if (borrowedJson != null && borrowedJson.isNotEmpty) {
      try {
        borrowedIds = List<int>.from(json.decode(borrowedJson));
      } catch (e) {
        borrowedIds = [];
      }
    }

    if (!borrowedIds.contains(widget.bookId)) {
      borrowedIds.add(widget.bookId);
      await prefs.setString('borrowed_books', json.encode(borrowedIds));
    }
    
    // =========================================================
    // 2. UPDATE STATUS KETERSEDIAAN DI DATA UTAMA ('book_data')
    // =========================================================
    final String? allBooksJson = prefs.getString('book_data');
    if (allBooksJson != null) {
      try {
        List<dynamic> decodedList = json.decode(allBooksJson);
        List<Map<String, dynamic>> allBooks = 
            decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
            
        // Cari dan perbarui status buku yang sedang dipinjam
        int index = allBooks.indexWhere((item) => item['id'] == widget.bookId);
        
        if (index != -1) {
          allBooks[index]['status'] = 'Dipinjam';
          // Simpan kembali daftar buku yang sudah diperbarui ke SharedPreferences
          await prefs.setString('book_data', json.encode(allBooks)); 
          
          // Update state lokal untuk merefresh UI
          if (mounted) {
            setState(() {
              _isBorrowed = true;
              _bookData!['status'] = 'Dipinjam'; // Update UI saat ini
            });
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buku berhasil dipinjam! Status ketersediaan diperbarui.')),
          );
        }

      } catch (e) {
        print('Error updating book status in book_data: $e');
      }
    }
  }


  // ================= BUILD UI ===================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _loadingState();
    }

    if (_bookData == null) {
      return _notFoundState();
    }

    final book = _bookData!;

    final String title = book['title'] ?? 'Tidak ada judul';
    final String author = book['author'] ?? '-';
    final String synopsys = book['synopsys'] ?? '-';
    // Gunakan status yang sudah diubah jika buku dipinjam
    final String status = book['status'] ?? 'Unavailable'; 
    final String image = book['image'] ?? '';

    final double rating = _convertRating(book['rating']);

    // Status 'Dipinjam' (atau selain 'Available') akan menggunakan warna merah
    final Color statusColor =
        status == 'Available' ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: _darkBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ========== IMAGE ==========
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: image.isNotEmpty
                      ? Image.asset(
                          image,
                          width: 200,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _imageErrorWidget(),
                        )
                      : _imageErrorWidget(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ========= TITLE ==========
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _darkBrown,
              ),
            ),

            const SizedBox(height: 10),

            _detailRow("Penulis", author, Icons.person),
            _ratingWidget(rating),
            // Tampilkan status yang sudah diperbarui
            _detailRow("Status", status,
                status == 'Available'
                    ? Icons.check_circle
                    : Icons.cancel, // Ikon merah untuk 'Dipinjam'
                color: statusColor),

            const Divider(height: 35, thickness: 1),

            const Text(
              "Sinopsis",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkBrown,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              synopsys,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),
            
            // -> Tombol Pinjam Buku
            _pinjamButton(), 

          ],
        ),
      ),
    );
  }

  // ================= HELPER =================

  Widget _pinjamButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isBorrowed ? null : _pinjamBuku, 
        icon: Icon(
          _isBorrowed ? Icons.check_circle_outline : Icons.book,
          color: Colors.white,
        ),
        label: Text(
          _isBorrowed ? "Buku Dipinjam" : "Pinjam Buku",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isBorrowed ? Colors.green : _darkBrown, 
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon,
      {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingWidget(double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Text(
            "Rating: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 5),
          ...List.generate(5, (index) {
            if (index + 1 <= rating) {
              return const Icon(Icons.star, color: Colors.amber, size: 18);
            } else if (index < rating) {
              return const Icon(Icons.star_half,
                  color: Colors.amber, size: 18);
            } else {
              return const Icon(Icons.star_border,
                  color: Colors.amber, size: 18);
            }
          }),
          const SizedBox(width: 6),
          Text(
            "${rating.toStringAsFixed(1)} / 5.0",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }

  double _convertRating(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Widget _imageErrorWidget() {
    return Container(
      width: 200,
      height: 260,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.book, size: 60, color: Colors.black45),
      ),
    );
  }

  Widget _loadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _notFoundState() {
    return const Scaffold(
      body: Center(
        child: Text(
          "Buku tidak ditemukan",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}