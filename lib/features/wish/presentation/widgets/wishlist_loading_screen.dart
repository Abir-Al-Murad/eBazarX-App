import 'package:flutter/material.dart';
import 'wishlist_shimmer.dart';

class WishlistLoadingScreen extends StatelessWidget {
  const WishlistLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const WishlistShimmer(),
      ),
    );
  }
}