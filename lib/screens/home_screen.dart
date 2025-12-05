import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ================= FILE UTAMA (main.dart) =================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 237, 185, 127)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= MODEL DATA (DENGAN SERIALISASI) =================
class Book {
  final String title;
  final String author;
  final double rating;
  final String coverAsset;
  final String synopsys;
  final String status;
  final String id;

  Book({
    required this.title,
    required this.author,
    required this.rating,
    required this.coverAsset,
    required this.synopsys,
    required this.status,
    String? id,
  }) : id = id ?? UniqueKey().toString();

  // Deserialisasi dari JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      // Handle jika rating disimpan sebagai int
      rating: json['rating'] is int
          ? (json['rating'] as int).toDouble()
          : json['rating'] as double,
      coverAsset: json['coverAsset'] as String,
      synopsys: json['synopsys'] as String,
      status: json['status'] as String,
    );
  }

  // Serialisasi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'coverAsset': coverAsset,
      'synopsys': synopsys,
      'status': status,
    };
  }
}

// ================= WIDGET UTAMA (HomeScreen) =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _autoPlayTimer;
  int _currentPage = 0;

  // Pastikan path assets ini benar
  final List<String> _carouselImages = [
    "assets/banner1.png",
    "assets/banner2.png",
    "assets/banner3.png",
  ];
  final List<String> _recomendationImages = [
    "assets/1.jpg",
    "assets/2.jpg",
    "assets/3.jpg",
    "assets/4.jpg",
    "assets/5.jpg",
    "assets/6.jpg",
    "assets/7.jpg",
    "assets/8.jpg",
  ];
  final List<String> _profileImages = ["assets/1.png"];

  List<Book> _booksData = [];
  bool _isLoading = true; // State untuk loading data

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _startAutoPlay();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ================= SAVE & LOAD DATA (SHARED PREFERENCES) =================

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        _booksData.map((book) => book.toJson()).toList();
    await prefs.setString("bookList", jsonEncode(jsonList));
  }

  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("bookList");

    if (data != null) {
      List decoded = jsonDecode(data);

      setState(() {
        _booksData = decoded.map((e) => Book.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      // Data statis awal jika Shared Prefs kosong
      setState(() {
        _booksData = [
          Book(
              title: "Menguasai Flutter",
              author: "Rizky Firmansyah",
              rating: 4.8,
              coverAsset: "assets/2.jpg",
              synopsys: "Penerbit Digital",
              status: "80% Selesai"),
          Book(
              title: "Filosofi Teras",
              author: "Henry Manampiring",
              rating: 4.5,
              coverAsset: "assets/3.jpg",
              synopsys: "Kompas Gramedia",
              status: "Baru Dimulai"),
          Book(
              title: "The Alchemist",
              author: "Paulo Coelho",
              rating: 4.7,
              coverAsset: "assets/4.jpg",
              synopsys: "HarperCollins",
              status: "Selesai"),
          Book(
              title: "Atomic Habits",
              author: "James Clear",
              rating: 4.9,
              coverAsset: "assets/1.jpg",
              synopsys: "Avery",
              status: "Membaca"),
        ];
        _isLoading = false;
      });
      _saveBooks(); // Simpan data statis ini sebagai awal
    }
  }

  // ================= FUNGSI CRUD =================

  void _addBook(Book newBook) {
    setState(() {
      _booksData.add(newBook);
    });
    _saveBooks();
  }

  // Mengedit buku berdasarkan ID (lebih aman)
  void _updateBook(String id, Book updatedBook) {
    final index = _booksData.indexWhere((book) => book.id == id);
    if (index != -1) {
      setState(() {
        _booksData[index] = updatedBook;
      });
      _saveBooks();
    }
  }

  // Menghapus buku berdasarkan ID
  void _deleteBook(String id) {
    setState(() {
      _booksData.removeWhere((book) => book.id == id);
    });
    _saveBooks();
  }

  // ================= DATA BUKU TERFILTER (LOGIKA SEARCH) =================
  List<Book> get _filteredBooks {
    if (_searchController.text.isEmpty) {
      return _booksData;
    }

    final query = _searchController.text.toLowerCase().trim();

    return _booksData.where((book) {
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();

      return titleLower.startsWith(query) || authorLower.startsWith(query);
    }).toList();
  }

  // ================= AUTOPLAY CAROUSEL =================
  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;

      int nextPage = _currentPage + 1;

      if (nextPage >= _carouselImages.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  // ================= FUNGSI PEMBANTU STATUS =================
  String _formatProgress(double progress) {
    if (progress == 0.0) return "Baru Dimulai";
    if (progress == 100.0) return "Selesai";
    return "${progress.toInt()}% Selesai";
  }

  // ================= DIALOG DETAIL BUKU (Placeholder) =================

  Future<void> _showBookDetailDialog(Book book) async {
    // Tentukan asset yang akan ditampilkan, gunakan default jika path kosong
    final String assetPath =
        book.coverAsset.isEmpty ? 'assets/1.jpg' : book.coverAsset;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Memperbaiki error dengan Image.asset dan menambahkan errorBuilder
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.asset(
                    assetPath, 
                    fit: BoxFit.cover,
                    // errorBuilder akan menangani asset yang tidak ditemukan
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey),
                              Text("Cover tidak ditemukan",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text('Penulis: ${book.author}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Sinopsis: ${book.synopsys}'),
                Text('Status: ${book.status}'),
                Row(
                  children: [
                    const Text('Rating: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildRatingStars(book.rating),
                    Text(' (${book.rating.toStringAsFixed(1)})'),
                  ],
                ),
                const SizedBox(height: 10),
                Text('ID Unik: ${book.id}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup Detail
                _showBookCrudDialog(existingBook: book); // Buka dialog Edit
              },
            ),
          ],
        );
      },
    );
  }

  // ================= DIALOG CRUD BARU (DENGAN PEMILIH BINTANG, SLIDER, & ASSET COVER) =================

  Future<void> _showBookCrudDialog({Book? existingBook}) async {
    final bool isEditing = existingBook != null;
    double initialProgress = 0.0;
    if (isEditing) {
      final statusText = existingBook!.status
          .replaceAll('% Selesai', '')
          .replaceAll('Baru Dimulai', '0')
          .replaceAll('Selesai', '100')
          .trim();
      initialProgress = double.tryParse(statusText) ?? 0.0;
    }

    final TextEditingController titleController =
        TextEditingController(text: existingBook?.title ?? '');
    final TextEditingController authorController =
        TextEditingController(text: existingBook?.author ?? '');
    final TextEditingController synopsysController =
        TextEditingController(text: existingBook?.synopsys ?? '');
    // Controller baru untuk Cover Asset. Default sekarang adalah string kosong ('')
    final TextEditingController coverAssetController =
        TextEditingController(text: existingBook?.coverAsset ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        double currentRating = existingBook?.rating ?? 0.0;
        double currentProgress = initialProgress;

        return AlertDialog(
          title: Text(isEditing ? 'Edit Buku' : 'Tambah Buku Baru'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Judul')),
                    TextField(
                        controller: authorController,
                        decoration: const InputDecoration(labelText: 'Penulis')),
                    TextField(
                        controller: synopsysController,
                        decoration:
                            const InputDecoration(labelText: 'Sinopsis')),
                    // TextField untuk Cover Asset
                    TextField(
                      controller: coverAssetController,
                      decoration: const InputDecoration(
                        labelText: 'Asset Cover (e.g., assets/1.jpg)',
                        hintText: 'assets/1.jpg',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- SLIDER PROGRESS STATUS ---
                    const Text('Progress Status',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_formatProgress(currentProgress),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.blueGrey)),
                    const SizedBox(height: 8),

                    Slider(
                      value: currentProgress,
                      min: 0.0,
                      max: 100.0,
                      divisions: 20, // Membagi menjadi 20 bagian (setiap 5%)
                      label: "${currentProgress.toInt()}%",
                      onChanged: (double newValue) {
                        setDialogState(() {
                          currentProgress = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- WIDGET PEMILIH RATING INTERAKTIF (BINTANG) ---
                    const Text('Rating',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        double fullValue = index + 1.0;
                        double halfValue = index + 0.5;

                        IconData icon;
                        Color color = Colors.amber;

                        if (currentRating >= fullValue) {
                          icon = Icons.star;
                        } else if (currentRating >= halfValue) {
                          icon = Icons.star_half;
                        } else {
                          icon = Icons.star_border;
                          color = Colors.grey;
                        }

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              // LOGIKA RATING:
                              if (currentRating == fullValue) {
                                currentRating = halfValue;
                              } else if (currentRating == halfValue) {
                                currentRating = fullValue;
                              } else if (currentRating < halfValue) {
                                currentRating = halfValue;
                              } else {
                                currentRating = fullValue;
                              }

                              if (currentRating > 5.0) {
                                currentRating = 5.0;
                              }
                            });
                          },
                          child: Icon(icon, color: color, size: 32),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        "Rating terpilih: ${currentRating.toStringAsFixed(1)} / 5.0",
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
          actions: [
            if (isEditing)
              TextButton(
                onPressed: () {
                  _deleteBook(existingBook!.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    authorController.text.isEmpty) {
                  return;
                }

                String finalStatus = _formatProgress(currentProgress);
                // Mengambil nilai Cover Asset
                String finalCoverAsset = coverAssetController.text.isEmpty
                    ? 'assets/1.jpg' // Default jika kosong
                    : coverAssetController.text;

                final newBook = Book(
                  id: existingBook?.id,
                  title: titleController.text,
                  author: authorController.text,
                  rating: currentRating,
                  coverAsset:
                      finalCoverAsset, // Menggunakan nilai dari controller baru
                  synopsys: synopsysController.text,
                  status: finalStatus, // Menggunakan status dari Slider
                );

                if (isEditing) {
                  _updateBook(existingBook!.id, newBook);
                } else {
                  _addBook(newBook);
                }
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }

  // ================= WIDGET BINTANG (RATING) =================

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
    }

    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 14));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  // ================= WIDGET LAINNYA =================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Chris 👋",
              style: TextStyle(
                color: Color.fromARGB(255, 45, 22, 0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Ayo cari buku favoritmu hari ini",
              style: TextStyle(
                color: Color.fromARGB(255, 45, 22, 0),
                fontSize: 14,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(_profileImages[0]),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari judul buku...",
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: const Icon(Icons.close, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _carouselImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.asset(
              _carouselImages[index],
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color.fromARGB(255, 45, 22, 0),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLastAccessedHorizontal() {
    final List<Book> dataToDisplay = _filteredBooks;

    if (_searchController.text.isNotEmpty && dataToDisplay.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Hasil Pencarian: Tidak ada buku ditemukan.",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
      );
    }

    // Jika tidak ada hasil, dan tidak sedang mencari, tampilkan pesan default
    if (dataToDisplay.isEmpty && _searchController.text.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Belum ada buku dalam daftar Anda. Tambahkan buku baru!",
              style: TextStyle(color: Colors.white70)),
        ),
      );
      underline: TextDecoration.none;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tampilkan judul hanya jika tidak sedang dalam mode pencarian
        if (_searchController.text.isEmpty)
          _buildSectionTitle("Terakhir Diakses"),

        // Tampilkan judul hasil pencarian jika sedang mencari
        if (_searchController.text.isNotEmpty)
          _buildSectionTitle("Hasil Pencarian"),

        const SizedBox(height: 12),

        SizedBox(
          height: 140, // Tinggikan sedikit untuk tombol Detail
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataToDisplay.length,
            itemBuilder: (context, index) {
              final book = dataToDisplay[index];

              return GestureDetector(
                onTap: () =>
                    _showBookCrudDialog(existingBook: book), // Membuka dialog edit
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          book.coverAsset,
                          height: 90,
                          width: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 90,
                              width: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 40, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildRatingStars(book.rating), // WIDGET BINTANG
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "(${book.status})",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.blueGrey),
                                    overflow: TextOverflow.ellipsis, // Tambahkan ini agar aman
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // TOMBOL DETAIL BARU
                            SizedBox(
                              height: 24,
                              child: TextButton(
                                onPressed: () => _showBookDetailDialog(book),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.centerLeft,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Detail',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageOnlyHorizontal() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionTitle("Rekomendasi"),
      const SizedBox(height: 4),
      const Text(
        "Buku-buku terbaik berdasarkan popularitas minggu ini",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recomendationImages.length,
          itemBuilder: (context, index) {
            // Hitung peringkat: Top 1, Top 2, ...
            final rank = index + 1;
            final rankText = "Top $rank";

            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(_recomendationImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
              // Gunakan Stack untuk overlay teks di atas gambar
              child: Stack(
                children: [
                  // Overlay teks "Top X" di pojok kiri atas
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54, // Background semi-transparan
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        rankText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildBookHorizontal() {
    final List<Book> dataToDisplay = _filteredBooks;

    if (dataToDisplay.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Populer"),
        const SizedBox(height: 12),
        SizedBox(
          height: 220, // Tinggikan sedikit untuk tombol Detail
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataToDisplay.length,
            itemBuilder: (context, index) {
              final book = dataToDisplay[index];

              return GestureDetector(
                onTap: () =>
                    _showBookCrudDialog(existingBook: book), // Membuka dialog edit
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          book.coverAsset,
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 110,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        // Menggunakan Expanded untuk mengatasi Overflow di bagian teks
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                book.author,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              _buildRatingStars(book.rating), // WIDGET BINTANG
                              const SizedBox(height: 4),
                              // TOMBOL DETAIL BARU
                              SizedBox(
                                height: 20,
                                child: TextButton(
                                  onPressed: () => _showBookDetailDialog(book),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Detail',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.blue)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= MAIN BUILD METHOD =================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Cek apakah mode pencarian aktif
    final isSearching = _searchController.text.isNotEmpty;

    return Scaffold(      
      body: Stack(
        children: [
          /// BACKGROUND IMAGE & OVERLAY
          Positioned.fill(
            child: Image.asset(
              "assets/background1.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // KAROUSEL hanya ditampilkan jika TIDAK sedang mencari
                  if (!isSearching) _buildCarousel(),
                  if (!isSearching) const SizedBox(height: 30),

                  // TERAKHIR DIAKSES / HASIL PENCARIAN
                  _buildLastAccessedHorizontal(),

                  // REKOMENDASI hanya ditampilkan jika TIDAK sedang mencari
                  if (!isSearching) const SizedBox(height: 30),
                  if (!isSearching) _buildImageOnlyHorizontal(),

                  // POPULER hanya ditampilkan jika TIDAK sedang mencari
                  if (!isSearching) const SizedBox(height: 30),
                  if (!isSearching) _buildBookHorizontal(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}