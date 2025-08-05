// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Banner
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Image.asset(
//                     'assets/images/banner.png',
//                     fit: BoxFit.fill,
//                     errorBuilder: (context, error, stackTrace) =>
//                     const Center(child: Icon(Icons.broken_image, size: 40)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: 24,
//
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Horizontal Categories
//
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Recommended for You',
//                 style: TextStyle(
//                   fontSize: 24,
//
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Grid of Products
//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 0.75,
//                 children: List.generate(4, (index) {
//                   return productCard(
//                     image: 'assets/images/jersey${index + 1}.png',
//                     name: 'Jersey',
//                     price: '\$${(index + 1) * 2}.99',
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   Widget categoryLogo(String path) {
//     return Image.asset(
//       path,
//       height: 40,
//       errorBuilder: (context, error, stackTrace) {
//         return const Icon(Icons.broken_image, size: 40, color: Colors.red);
//       },
//     );
//   }
//
//   Widget productCard({
//     required String image,
//     required String name,
//     required String price,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(2, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: Image.asset(
//                 image,
//                 fit: BoxFit.fill,
//                 errorBuilder: (context, error, stackTrace) =>
//                 const Center(child: Icon(Icons.broken_image, size: 40)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: const TextStyle(
//                        fontSize: 15)),
//                 const SizedBox(height: 4),
//                 Text(price,
//                     style: TextStyle(
//                         color: Colors.deepOrange.shade700,
//                         fontWeight: FontWeight.bold)),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
