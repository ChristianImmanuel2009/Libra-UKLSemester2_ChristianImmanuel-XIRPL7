// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class MyCarousel extends StatelessWidget {
//   const MyCarousel({super.key});

//   final List<String> imageList = const [
//     'assets/1.jpg',
//     'assets/2.jpg',
//     'assets/3.jpg',
//     'assets/4.jpg',
//     'assets/5.jpg',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 200,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         viewportFraction: 0.85,
//       ),
//       items: imageList.map((imagePath) {
//         return Builder(
//           builder: (BuildContext context) {
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.cover,
//                 width: MediaQuery.of(context).size.width,
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
// }
