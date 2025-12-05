// lib/screens/linimasa_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_konten_screen.dart';
const Color _lightBrown = Color(0xFF795548); // Warna untuk FAB

class LinimasaScreen extends StatefulWidget {
  const LinimasaScreen({super.key});

  @override
  State<LinimasaScreen> createState() => _LinimasaScreenState();
}

class _LinimasaScreenState extends State<LinimasaScreen> {
  // Warna konsisten
  static const Color _darkBrown = Color(0xFF2D1600);
  static const Color _lightBrown = Color(0xFF795548); // Warna untuk FAB

  // bookList diinisialisasi sebagai list kosong.
  List<Map<String, dynamic>> bookList = [];

  // Data awal (Sudah DIVERIFIKASI memiliki 6 item dengan ID UNIK)
  final List<Map<String, dynamic>> _initialBookList = [
    {
    "id": 1,
    "image": "assets/1.jpg",
    "title": "Bumi Manusia",
    "author": "Pramoedya Ananta Toer",
    "publisher": "Hasta Mitra",
    "status": "Available",
    "rating": 4.5,
    "synopsys": "Kisah Minke, seorang pribumi terpelajar yang berkesempatan mengenyam pendidikan Belanda di awal abad ke-20. Ia jatuh cinta dengan Annelies Mellema, seorang gadis Indo-Belanda. Melalui kisah cinta mereka yang penuh gejolak, novel ini menggambarkan secara mendalam pergolakan batin dan sosial seorang individu di Hindia Belanda, menyoroti isu-isu kolonialisme, diskriminasi ras, dan perjuangan mencari martabat di tanah sendiri."
  },
  {
    "id": 2,
    "image": "assets/2.jpg",
    "title": "Menguasai Flutter",
    "author": "Rizky Firmansyah",
    "publisher": "Erlangga",
    "status": "Available",
    "rating": 4.0,
    "synopsys": "Panduan komprehensif ini dirancang untuk pengembang dari segala tingkatan, memberikan langkah-langkah praktis dan mendalam untuk mengembangkan aplikasi mobile multi-platform (Android dan iOS) yang indah dan berkinerja tinggi menggunakan Flutter, framework dari Google. Pembahasan meliputi dasar-dasar Dart, manajemen state, integrasi API, hingga tips dan trik deployment aplikasi ke store."
  },
  {
    "id": 3,
    "image": "assets/3.jpg",
    "title": "Laskar Pelangi",
    "author": "Andrea Hirata",
    "publisher": "Bentang Pustaka",
    "status": "Available",
    "rating": 5.0,
    "synopsys": "Berdasarkan kisah nyata, novel ini menceritakan perjuangan hidup dan pendidikan sepuluh anak Melayu dari keluarga miskin di Belitong yang bersekolah di sebuah sekolah Muhammadiyah yang nyaris roboh. Meskipun dengan segala keterbatasan, semangat mereka untuk belajar yang didorong oleh dua guru yang berdedikasi tinggi menginspirasi banyak orang dan membuktikan bahwa pendidikan adalah kunci untuk meraih impian, bahkan dari kondisi yang paling sulit sekalipun."
  },
  {
    "id": 4,
    "image": "assets/4.jpg",
    "title": "Anak Semua Bangsa",
    "author": "Pramoedya Ananta Toer",
    "publisher": "Hasta Mitra",
    "status": "Available",
    "rating": 4.8,
    "synopsys": "Merupakan buku kedua dalam tetralogi Buru, novel ini melanjutkan kisah Minke setelah peristiwa tragis yang menimpanya. Ia mulai menyadari identitasnya di tengah cengkeraman kolonialisme yang semakin kuat. Minke bergulat dengan idealisme, realitas sosial, dan upayanya untuk mengabdikan ilmu dan tulisannya bagi rakyatnya, sebuah refleksi mendalam tentang pergulatan identitas dan kesadaran kebangsaan."
  },
  {
    "id": 5,
    "image": "assets/5.jpg",
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "publisher": "Pearson Education",
    "status": "Available",
    "rating": 4.7,
    "synopsys": "Buku wajib ini menyajikan prinsip-prinsip, pola, dan praktik terbaik untuk menulis kode sumber yang tidak hanya berfungsi, tetapi juga bersih, mudah dibaca, dan mudah dipelihara. Ditujukan untuk semua pengembang perangkat lunak, buku ini membahas cara penamaan variabel, fungsi, struktur kelas, hingga penanganan error yang efektif, mengubah kode yang buruk menjadi karya yang profesional."
  },
  {
    "id": 6,
    "image": "assets/6.jpg",
    "title": "Ayat-Ayat Cinta",
    "author": "Habiburrahman El Shirazy",
    "publisher": "Republika",
    "status": "Available",
    "rating": 4.2,
    "synopsys": "Kisah romansa religius ini berpusat pada Fahri, seorang mahasiswa Indonesia yang menuntut ilmu di Universitas Al-Azhar, Kairo, Mesir. Dalam kehidupannya yang diwarnai kesederhanaan dan ketekunan, ia dihadapkan pada dilema cinta dan perjodohan. Novel ini mengeksplorasi makna cinta sejati, kesetiaan, dan bagaimana prinsip-prinsip Islam membimbing seseorang dalam menghadapi masalah percintaan dan kehidupan sosial."
  }
  ];

  @override
  void initState() {
    super.initState();
    _loadBookList(); // Muat data saat state diinisialisasi
  }

  // ==================== FUNGSI PERSISTENCY ====================

  // Menyimpan data buku ke SharedPreferences (dikonversi ke JSON string)
  Future<void> _saveBookList() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(bookList);
    await prefs.setString('book_data', jsonString);
  }

  // Memuat data buku dari SharedPreferences
  Future<void> _loadBookList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('book_data');

    if (jsonString != null && jsonString.isNotEmpty) {
      // Jika ada data tersimpan, muat data tersebut
      final List<dynamic> decodedList = json.decode(jsonString);
      setState(() {
        bookList = decodedList.cast<Map<String, dynamic>>();
      });
    } else {
      // Jika tidak ada data tersimpan (pertama kali dijalankan), gunakan data awal
      setState(() {
        bookList = _initialBookList;
      });
      // Simpan data awal agar tidak memuat ulang setiap saat
      _saveBookList();
    }
  }

  // ==================== FUNGSI CRUD DENGAN PERSISTENCY ====================

  // FUNGSI BARU UNTUK MENAMBAH BUKU
  void _addBook(
    String image,
    String title,
    String author,
    String synopsys,
    String status,
    double rating,
  ) {
    setState(() {
      // Mencari ID tertinggi yang ada untuk menghindari duplikasi ID
      final int newId = bookList.isNotEmpty
          ? (bookList.map((book) => book['id'] as int).reduce((a, b) => a > b ? a : b) + 1)
          : 1;

      final newBook = {
        "id": newId,
        "image": image.isEmpty ? "assets/default.jpg" : image, // Gunakan default jika kosong
        "title": title,
        "author": author,
        "synopsys": synopsys,
        "status": status,
        "rating": rating,
        
      };

      bookList.insert(0, newBook); // Tambahkan buku baru di awal daftar

      // Panggil fungsi simpan setelah tambah di state
      _saveBookList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Buku "${title}" berhasil ditambahkan!',
          ),
        ),
      );
    });
  }

  // FUNGSI INI DIUBAH UNTUK MENERIMA ARGUMEN newImage
  void _updateBook(
    int id,
    String newImage, // <-- ARGUMEN BARU DITAMBAHKAN
    String newTitle,
    String newAuthor,
    String newsynopsys,
    String newStatus,
    double newRating,
  ) {
    setState(() {
      final index = bookList.indexWhere((book) => book['id'] == id);
      if (index != -1) { // <-- SIMPAN PATH GAMBAR BARU
        bookList[index]['title'] = newTitle;
        bookList[index]['author'] = newAuthor;
        bookList[index]['synopsys'] = newsynopsys;
        bookList[index]['image'] = newImage; // <-- SIMPAN PATH GAMBAR BARU 
        bookList[index]['status'] = newStatus;
        bookList[index]['rating'] = newRating;

        // Panggil fungsi simpan setelah update di state
        _saveBookList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Buku "${newTitle}" berhasil diupdate! Rating: ${newRating.toStringAsFixed(1)}',
            ),
          ),
        );
      }
    });
  }

  void _deleteBook(int id, String title) {
    setState(() {
      bookList.removeWhere((book) => book['id'] == id);

      // Panggil fungsi simpan setelah delete di state
      _saveBookList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Buku "${title}" berhasil dihapus.')),
    );
  }

  // ==================== DIALOG TAMBAH BUKU BARU (POP UP) ====================
  Future<void> _showAddDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController authorController = TextEditingController();
    final TextEditingController synopsysController = TextEditingController();
    final TextEditingController imageController = TextEditingController(
        text: ''); // Default path

    String currentStatus = 'Available';
    double currentRating = 0.0;
    
    // 
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Tambah Buku Baru',
            style: TextStyle(color: const Color.fromARGB(255, 237, 185, 127),),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // INPUT Judul
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Judul'),
                    ),
                    // INPUT Penulis
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(labelText: 'Penulis'),
                    ),
                    // INPUT Penerbit
                    TextField(
                      controller: synopsysController,
                      decoration: const InputDecoration(labelText: 'synopsys'),
                    ),
                    // INPUT Path Gambar
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        labelText: 'Asset Cover (e.g., assets/7.jpg)',
                        hintText: 'assets/default.jpg',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown Status
                    const Text(
                      'Progress Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: currentStatus,
                      isExpanded: true,
                      items: <String>['Available', 'Dipinjam']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            currentStatus = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // INPUT RATING BINTANG
                    const Text(
                      'Rating:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        // Menentukan ikon bintang
                        IconData iconData;
                        if (index + 1 <= currentRating) {
                          iconData = Icons.star;
                        } else if (index < currentRating &&
                            index + 1 > currentRating) {
                          iconData = Icons.star_half;
                        } else {
                          iconData = Icons.star_border;
                        }

                        // Widget yang dapat diklik untuk mengatur rating 0.5
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              double newRating = index + 1.0;

                              // Logic untuk mengatur rating dengan step 0.5
                              if (currentRating == index + 1.0) {
                                newRating = index + 0.5;
                              } else if (currentRating > index + 0.5 &&
                                  currentRating < index + 1.0) {
                                newRating = index + 1.0;
                              } else if (currentRating < index + 0.5) {
                                newRating = index + 0.5;
                              }

                              // Handle khusus untuk klik bintang ke-5 dan rating 5.0
                              if (index == 4 &&
                                  currentRating == 5.0 &&
                                  newRating == 5.0) {
                                newRating = 4.5;
                              }

                              currentRating = newRating.clamp(0.0, 5.0);
                            });
                          },
                          child: Icon(iconData, color: Colors.amber, size: 28),
                        );
                      }),
                    ),
                    Text(
                      'Rating terpilih: ${currentRating.toStringAsFixed(1)} / 5.0',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Tambah',
                style: TextStyle(
                  color: const Color.fromARGB(255, 237, 185, 127),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    synopsysController.text.isNotEmpty) {
                  _addBook(
                    imageController.text,
                    titleController.text,
                    authorController.text,
                    synopsysController.text,
                    currentStatus,
                    currentRating,
                  );
                  Navigator.of(context).pop();
                } else {
                  // Tambahkan notifikasi jika ada field wajib yang kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Judul, Penulis, dan Penerbit wajib diisi.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ==================== DIALOG EDIT BUKU (POP UP) ====================
  // FUNGSI INI DIUBAH UNTUK MENAMPILKAN FIELD INPUT GAMBAR
  Future<void> _showEditDialog(Map<String, dynamic> book) async {
    final TextEditingController titleController = TextEditingController(
      text: book['title'],
    );
    final TextEditingController authorController = TextEditingController(
      text: book['author'],
    );
    final TextEditingController synopsysController = TextEditingController(
      text: book['synopsys'],
    );
    // CONTROLLER BARU UNTUK GAMBAR
    final TextEditingController imageController = TextEditingController(
      text: book['image'],
    );

    String currentStatus = book['status'];
    double currentRating = book['rating'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Informasi Buku',
            style: TextStyle(color: _darkBrown),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // INPUT LAINNYA
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Judul'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(labelText: 'Penulis'),
                    ),
                    TextField(
                      controller: synopsysController,
                      decoration: const InputDecoration(labelText: 'Sinopsis'),
                    ),
                    // INPUT BARU UNTUK PATH GAMBAR
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        labelText: 'Path Gambar (e.g., assets/7.jpg)',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown Status
                    const Text(
                      'Status Ketersediaan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: currentStatus,
                      isExpanded: true,
                      items: <String>['Available', 'Dipinjam']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            currentStatus = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // INPUT RATING BINTANG
                    const Text(
                      'Rating:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        // Menentukan ikon bintang
                        IconData iconData;
                        if (index + 1 <= currentRating) {
                          iconData = Icons.star;
                        } else if (index < currentRating &&
                            index + 1 > currentRating) {
                          iconData = Icons.star_half;
                        } else {
                          iconData = Icons.star_border;
                        }

                        // Widget yang dapat diklik untuk mengatur rating 0.5
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              double newRating = index + 1.0;

                              // Logic untuk mengatur rating dengan step 0.5
                              if (currentRating == index + 1.0) {
                                newRating = index + 0.5;
                              } else if (currentRating > index + 0.5 &&
                                  currentRating < index + 1.0) {
                                newRating = index + 1.0;
                              } else if (currentRating < index + 0.5) {
                                newRating = index + 0.5;
                              }

                              // Handle khusus untuk klik bintang ke-5 dan rating 5.0
                              if (index == 4 &&
                                  currentRating == 5.0 &&
                                  newRating == 5.0) {
                                newRating = 4.5;
                              }

                              currentRating = newRating.clamp(0.0, 5.0);
                            });
                          },
                          child: Icon(iconData, color: Colors.amber, size: 28),
                        );
                      }),
                    ),
                    Text(
                      '${currentRating.toStringAsFixed(1)} / 5.0',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: _darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    synopsysController.text.isNotEmpty) {
                  // Panggil _updateBook dengan MENYERTAKAN PATH GAMBAR BARU
                  _updateBook(
                    book['id'],
                    imageController.text, // <-- MENGIRIM PATH GAMBAR BARU
                    titleController.text,
                    authorController.text,
                    synopsysController.text,
                    currentStatus,
                    currentRating,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // DIALOG HAPUS BUKU (POP UP)
  Future<void> _showDeleteConfirmation(int id, String title) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Anda yakin ingin menghapus buku "${title}" dari daftar?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: _darkBrown)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Panggil _deleteBook yang sekarang sudah mengandung _saveBookList()
                _deleteBook(id, title);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Opsi Edit/Hapus (Modal Bottom Sheet) - (TIDAK ADA PERUBAHAN)
  void _showMoreOptions(BuildContext context, Map<String, dynamic> book) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Opsi untuk: ${book["title"]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _darkBrown,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit, color: _darkBrown),
              title: const Text(
                'Edit Buku',
                style: TextStyle(color: _darkBrown),
              ),
              onTap: () {
                Navigator.pop(bc);
                _showEditDialog(book);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Hapus Buku',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(bc);
                _showDeleteConfirmation(book["id"], book["title"]);
              },
            ),
          ],
        );
      },
    );
  }

  // ==================== BUILD METHOD UTAMA ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.brown[50],
      // Tambahkan FloatingActionButton di sini
      floatingActionButton: FloatingActionButton.extended(
    onPressed: _showAddDialog,
    icon: const Icon(Icons.add, color: Colors.white), // Ikon putih
    label: const Text(
      'Tambah Buku',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600), // Teks putih
    ),
    backgroundColor: const Color.fromARGB(255, 237, 185, 127), // Gunakan warna coklat terang (_lightBrown)
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0), // Bentuk yang sedikit membulat
    ),
),

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset("assets/background1.png", fit: BoxFit.cover),
          ),
          // Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Linimasa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Linimasa Aktivitas 📚",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cek jika data masih kosong (saat loading atau error)
                    if (bookList.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(color: _darkBrown),
                        ),
                      )
                    else
                      // Daftar Buku (Book Cards)
                      ...bookList.map((book) {
                        final isAvailable = book["status"] == "Available";
                        final statusColor = isAvailable
                            ? Colors.green.shade600
                            : Colors.red.shade600;
                        final rating = book["rating"] as double;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _darkBrown.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Gambar Buku
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      book["image"]!,
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 15),

                                  // 2. Judul, Penulis, Status
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book["title"]!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: _darkBrown,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Oleh: ${book["author"]} (${book["synopsys"]})",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // TAMPILAN RATING BINTANG
                                        Row(
                                          children: List.generate(5, (index) {
                                            IconData iconData;
                                            if (index + 1 <= rating) {
                                              iconData = Icons.star;
                                            } else if (index < rating &&
                                                index + 1 > rating) {
                                              iconData = Icons.star_half;
                                            } else {
                                              iconData = Icons.star_border;
                                            }
                                            return Icon(
                                              iconData,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 8),

                                        // KETERANGAN STATUS
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            book["status"]!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 3. Tombol Titik Tiga (More Options)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () =>
                                        _showMoreOptions(context, book),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              const Divider(height: 1, color: Colors.grey),
                              const SizedBox(height: 5),

                              // 4. Baris Tombol Aksi (Detail)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 18,
                                    color: _darkBrown,
                                  ),
                                  label: const Text(
                                    "Lihat Detail",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _darkBrown,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // 1. Panggil Navigator.push dan kirim ID BUKU ('id')
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // Kunci yang diterima DetailKontenScreen sekarang adalah 'bookId'
                                        builder: (context) =>
                                            DetailKontenScreen(
                                              bookId: book['id']!,
                                            ),
                                      ),
                                    );

                                    // 2. Muat ulang daftar buku saat kembali ke LinimasaScreen
                                    _loadBookList();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 30),

                    const SizedBox(height: 100),
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