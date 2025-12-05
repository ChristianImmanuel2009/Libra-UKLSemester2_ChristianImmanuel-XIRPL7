class BookModel {
  final int id;         // Kunci wajib untuk identifikasi
  final String title;
  final String author;
  final double rating;
  final String? image;  // Path gambar (dibuat nullable)
  final String? synopsys;
  final String? status; // Status ketersediaan (dibuat nullable, akan diisi di SharedPreferences)

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    this.image,
    this.synopsys,
    this.status = 'Available', // Beri nilai default
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'image': image,
      'synopsys': synopsys,
      'status': status, // Sertakan status saat menyimpan
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String?,
      synopsys: json['synopsys'] as String?,
      // Ambil status dari JSON, jika tidak ada (null), defaultkan ke 'Available'
      status: json['status'] as String? ?? 'Available', 
    );
  }
}