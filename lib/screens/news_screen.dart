// Updated NewsScreen with card UI matching prototype
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF5D4037);
    const Color backButtonBrown = Color.fromARGB(255, 93, 57, 44);

    final List<Map<String, String>> newsList = [
      {
        "image": "assets/5.jpg",
        "title":
            "Kopi Susu Gula Aren Masih Jadi Primadona, Apa Rahasia di Baliknya?",
        "desc":
            "Minuman kekinian ini tidak hanya populer di kalangan anak muda, tetapi juga terus menguasai menu kedai kopi. Banyak yang bertanya, apa yang membuat racikan sederhana kopi, susu, dan gula aren selalu laris?",
      },
      {
        "image": "assets/4.jpg",
        "title":
            "Tren Kopi Single Origin Terus Meningkat: Apakah Konsumen Semakin Selektif?",
        "desc":
            "Permintaan terhadap kopi yang ditanam di satu wilayah spesifik (single origin) menunjukkan pertumbuhan signifikan. Ini mengindikasikan pergeseran minat konsumen dari blended ke varietas unik yang menonjolkan karakter rasa.",
      },
      {
        "image": "assets/3.jpg",
        "title":
            "Inovasi Kedai Kopi: Menggabungkan Budaya Lokal dan Pengalaman Digital",
        "desc":
            "Kedai kopi kekinian semakin kreatif dalam menarik pelanggan. Mulai dari desain interior yang mengadopsi elemen budaya daerah hingga pemanfaatan aplikasi pemesanan dan loyalty program berbasis digital.",
      },
      {
        "image": "assets/2.jpg",
        "title": "Dampak Perubahan Iklim Terhadap Produksi Kopi Arabika Global",
        "desc":
            "Para ahli memperingatkan bahwa kenaikan suhu dan pola hujan yang tidak menentu mengancam area tanam kopi Arabika. Hal ini memicu penelitian untuk mengembangkan varietas kopi yang lebih tangguh terhadap iklim.",
      },
      {
        "image": "assets/1.jpg",
        "title":
            "Kopi Non-Kafein (Decaf) Mulai Dilirik: Bukan Lagi Pilihan Kedua",
        "desc":
            "Konsumsi kopi decaf semakin populer, didorong oleh kesadaran kesehatan dan gaya hidup. Produsen mulai berinvestasi dalam metode dekafeinasi yang mempertahankan kualitas dan rasa asli biji kopi.",
      },
      {
        "image": "assets/5.jpg",
        "title": "Bagaimana Kopi Indonesia Menguasai Pasar Internasional?",
        "desc":
            "Berita mengenai ekspor kopi Indonesia, terutama varietas unggulan seperti Mandailing, Gayo, dan Toraja, yang permintaannya terus bertambah di pasar Eropa dan Amerika.",
      },
      {
        "image": "assets/4.jpg",
        "title":
            "Memahami Fenomena Coffee Roaster Lokal: Dari Hobi Menjadi Bisnis Profesional",
        "desc":
            "Semakin banyak micro-roaster atau sangrai kopi skala kecil yang muncul. Mereka fokus pada kualitas biji mentah dan profil roasting yang unik, menciptakan diferensiasi di pasar.",
      },
      {
        "image": "assets/3.jpg",
        "title":
            "Teknologi Baru dalam Pengolahan Kopi: Dari Fermentasi hingga Mesin Penyeduh Otomatis",
        "desc":
            "Laporan tentang metode pengolahan pascapanen kopi (misalnya fermentasi anaerob) yang memberikan dimensi rasa baru, serta perkembangan mesin kopi otomatis dengan presisi tinggi.",
      },
      {
        "image": "assets/2.jpg",
        "title":
            "Manfaat Kesehatan Kopi yang Sering Diabaikan: Lebih dari Sekadar Energi",
        "desc":
            "Ulasan mengenai penelitian terbaru yang menyoroti kopi sebagai sumber antioksidan dan hubungannya dengan penurunan risiko penyakit tertentu, menanggapi mitos kesehatan yang keliru.",
      },
      {
        "image": "assets/1.jpg",
        "title":
            "Persaingan Harga Biji Kopi di Tingkat Petani: Tantangan dan Solusi Keberlanjutan",
        "desc":
            "Isu mengenai fluktuasi harga komoditas kopi global dan dampaknya pada kesejahteraan petani. Termasuk inisiatif fair trade dan rantai pasok langsung (direct trade).",
      },
      {
        "image": "assets/5.jpg",
        "title":
            "Kopi sebagai Destinasi Wisata: Munculnya Coffee Tourism di Daerah Penghasil Kopi",
        "desc":
            "Tren wisata baru di mana wisatawan mengunjungi perkebunan, mengikuti proses panen, dan mencicipi kopi langsung di sumbernya, seperti di Jawa, Bali, atau Flores.",
      },
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.brown[50],
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgroundHome1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
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
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: backButtonBrown,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "News",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // PROTOTYPE NEWS CARD
                    Column(
                      children: newsList.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  item["image"]!,
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      "Berita Hot ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    Text("🔥", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                item["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                item["desc"]!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(221, 106, 106, 106),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Baca Selengkapnya..",
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 1),
    );
  }
}
