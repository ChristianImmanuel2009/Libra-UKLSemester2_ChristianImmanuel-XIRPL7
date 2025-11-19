import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Daftar data kopi agar bisa dihapus / diedit / ditambah
  List<Map<String, String>> coffeeList = [
    {
      "name": "Café au Lait",
      "method": "Kopi Hitam + Susu",
      "taste": "Lembut",
      "origin": "Prancis",
      "img": "assets/1.jpg",
    },
    {
      "name": "Lungo",
      "method": "Espresso + Air (+)",
      "taste": "Lebih Ringan",
      "origin": "Italia",
      "img": "assets/2.jpg",
    },
    {
      "name": "Flat White",
      "method": "Espresso + Milk",
      "taste": "Espresso Kuat",
      "origin": "Australia/Selandia Baru",
      "img": "assets/3.jpg",
    },
    {
      "name": "Cortado",
      "method": "Espresso + Susu",
      "taste": "Pekat Susu",
      "origin": "Spanyol/Basque",
      "img": "assets/4.jpg",
    },
    {
      "name": "Espresso Macchiato",
      "method": "Espresso + Susu",
      "taste": "Kuat, Lembut",
      "origin": "Italia",
      "img": "assets/5.jpg",
    },
    {
      "name": "Espresso",
      "method": "Ekstraksi biji kopi",
      "taste": "Pekat, Pahit",
      "origin": "Italia",
      "img": "assets/1.jpg",
    },
    {
      "name": "Americano",
      "method": "Espresso + Air",
      "taste": "Kuat, Encer",
      "origin": "Amerika Serikat",
      "img": "assets/2.jpg",
    },
    {
      "name": "Cappuccino",
      "method": "Espresso + Susu",
      "taste": "Seimbang",
      "origin": "Italia",
      "img": "assets/3.jpg",
    },
    {
      "name": "Caffè Latte",
      "method": "Espresso + Steamed Milk",
      "taste": "Susu Dominan",
      "origin": "Italia",
      "img": "assets/4.jpg",
    },
    {
      "name": "Mocha",
      "method": "Espresso + Steamed Milk",
      "taste": "Cokelat, Creamy",
      "origin": "Yaman (asal biji kopi)",
      "img": "assets/5.jpg",
    },
  ];

  // --- Carousel (PageView) tanpa paket eksternal ---
  final PageController _pageController = PageController(
    viewportFraction: 1.0,
    initialPage: 0,
  );
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  final List<String> _carouselImages = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    _pageController.addListener(() {
      // optional: bisa dipakai jika perlu
    });
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselImages.isEmpty || !_pageController.hasClients) return;
      int next = (_currentPage + 1) % _carouselImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // --- END Carousel ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavbar(currentIndex: 2),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/header.jpg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          // Overlay gelap lembut agar teks lebih jelas
          Container(color: Colors.black.withOpacity(0.2)),

          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/IconSPlash.png", height: 35),
                            const SizedBox(width: 8),
                            const Text(
                              "TokoKopiKu",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 55, 36, 22),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            // 🟤 Tambahkan fungsi tambah data
                            onPressed: () {
                              _showAddDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Greeting
                  const Center(
                    child: Text(
                      "Hi Chris!",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 20),

                  // 🔥 Search Bar
                  Center(
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 72, 34, 0),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Top 5 Minuman Kopi Terfavorit...",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 72, 34, 0),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // List Kopi Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/backgroundHome1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- CAROUSEL START (replace your old carousel block with this) ---
                          SizedBox(
                            height: 150,
                            child: Column(
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: _carouselImages.length,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      final path = _carouselImages[index];

                                      // Use AnimatedBuilder but guard against any PageController exceptions
                                      return AnimatedBuilder(
                                        animation: _pageController,
                                        builder: (context, child) {
                                          double value = 1.0;

                                          // Defensive: try/catch to avoid any unexpected Controller errors
                                          try {
                                            if (_pageController.hasClients) {
                                              // page can be null sometimes, so fallback to _currentPage
                                              final double page =
                                                  (_pageController.page ??
                                                  _currentPage.toDouble());
                                              value =
                                                  (1 -
                                                          ((page - index)
                                                                  .abs() *
                                                              0.30))
                                                      .clamp(0.0, 1.0);
                                            } else {
                                              // Controller has no clients yet — use current index as fallback
                                              value = (_currentPage == index)
                                                  ? 1.0
                                                  : 0.85;
                                            }
                                          } catch (e) {
                                            // Extreme fallback: don't crash, use simple scale based on whether it's active
                                            value = (_currentPage == index)
                                                ? 1.0
                                                : 0.85;
                                          }

                                          // Apply a small easing so scale looks nicer
                                          final double scale = Curves.easeOut
                                              .transform(value);

                                          return Center(
                                            child: Transform.scale(
                                              scale: scale,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Image.asset(
                                                    path,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Dots indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _carouselImages.length,
                                    (i) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: _currentPage == i ? 18 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _currentPage == i
                                            ? const Color(0xFF6F4E37)
                                            : Colors.white70,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // --- CAROUSEL END ---
                          const SizedBox(height: 20,),
                          const Text(
                            "List Minuman Kopi Best Seller",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F4E37),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Top 5 Minuman Kopi paling Laku di Cafe!",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 20),

                          // List Kopi Dinamis
                          Column(
                            children: List.generate(coffeeList.length, (index) {
                              final coffee = coffeeList[index];
                              return _coffeeCard(
                                context,
                                index,
                                coffee["name"]!,
                                coffee["method"]!,
                                coffee["taste"]!,
                                coffee["origin"]!,
                                coffee["img"]!,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget kartu kopi dengan fungsi edit & hapus
  Widget _coffeeCard(
    BuildContext context,
    int index,
    String name,
    String method,
    String taste,
    String origin,
    String imgPath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFECE0D1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imgPath, width: 55, height: 55, fit: BoxFit.cover),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF4B2E05),
          ),
        ),
        subtitle: Text(
          "Metode: $method\nCita Rasa: $taste\nAsal: $origin",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Color(0xFF4B2E05)),
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context, index);
            } else if (value == 'delete') {
              setState(() {
                coffeeList.removeAt(index);
              });
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }

  // Pop up edit
  void _showEditDialog(BuildContext context, int index) {
    final nameController = TextEditingController(
      text: coffeeList[index]["name"],
    );
    final methodController = TextEditingController(
      text: coffeeList[index]["method"],
    );
    final tasteController = TextEditingController(
      text: coffeeList[index]["taste"],
    );
    final originController = TextEditingController(
      text: coffeeList[index]["origin"],
    );
    final imageController = TextEditingController(
      text: coffeeList[index]["img"],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFECE0D1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Data Kopi",
            style: TextStyle(color: Color(0xFF4B2E05)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Kopi"),
                ),
                TextField(
                  controller: methodController,
                  decoration: const InputDecoration(labelText: "Metode"),
                ),
                TextField(
                  controller: tasteController,
                  decoration: const InputDecoration(labelText: "Cita Rasa"),
                ),
                TextField(
                  controller: originController,
                  decoration: const InputDecoration(labelText: "Asal"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Image"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
              ),
              onPressed: () {
                setState(() {
                  coffeeList.removeAt(index);
                  coffeeList.insert(index, {
                    "name": nameController.text,
                    "method": methodController.text,
                    "taste": tasteController.text,
                    "origin": originController.text,
                    "img": imageController.text,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🟢 Pop up tambah data kopi
  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final methodController = TextEditingController();
    final tasteController = TextEditingController();
    final originController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFECE0D1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Tambah Data Kopi Baru",
            style: TextStyle(color: Color(0xFF4B2E05)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Kopi"),
                ),
                TextField(
                  controller: methodController,
                  decoration: const InputDecoration(labelText: "Metode"),
                ),
                TextField(
                  controller: tasteController,
                  decoration: const InputDecoration(labelText: "Cita Rasa"),
                ),
                TextField(
                  controller: originController,
                  decoration: const InputDecoration(labelText: "Asal"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: "Path Gambar (cth: assets/1.jpg)",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
              ),
              onPressed: () {
                setState(() {
                  coffeeList.insert(0, {
                    "name": nameController.text,
                    "method": methodController.text,
                    "taste": tasteController.text,
                    "origin": originController.text,
                    "img": "assets/1.jpg", // bisa disesuaikan nanti
                  });
                });

                Navigator.pop(context);
              },
              child: const Text(
                "Tambah",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
