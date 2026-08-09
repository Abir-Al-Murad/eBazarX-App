// import 'package:flutter/material.dart';
//
// class SellerSection extends StatelessWidget {
//   final Seller seller;
//
//   const SellerSection({super.key, required this.seller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 24,
//               backgroundColor: Colors.grey.shade200,
//               child: Text(
//                 seller.name[0].toUpperCase(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     seller.name,
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                         size: 14,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         seller.rating.toString(),
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         width: 1,
//                         height: 12,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${seller.totalSales} sales',
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to seller profile
//               },
//               child: const Text('View Shop'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }