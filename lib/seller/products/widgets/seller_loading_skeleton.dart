import 'package:flutter/material.dart';

class SellerLoadingSkeleton extends StatelessWidget {
  const SellerLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image gallery placeholder
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        // Basic info placeholder
        Container(height: 20, width: 200, color: Colors.grey[300]),
        const SizedBox(height: 8),
        Container(height: 16, width: 150, color: Colors.grey[300]),
        const SizedBox(height: 8),
        Container(height: 16, width: 100, color: Colors.grey[300]),
        const SizedBox(height: 16),
        // Price card placeholder
        Container(height: 80, color: Colors.grey[200]),
        const SizedBox(height: 16),
        // Statistics placeholder
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          children: List.generate(6, (_) => Container(
            margin: const EdgeInsets.all(4),
            height: 40,
            color: Colors.grey[300],
          )),
        ),
        const SizedBox(height: 16),
        // Description placeholder
        Container(height: 100, color: Colors.grey[200]),
        const SizedBox(height: 16),
        // Variants placeholder
        Container(height: 150, color: Colors.grey[200]),
      ],
    );
  }
}