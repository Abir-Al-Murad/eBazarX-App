import 'package:flutter/material.dart';

class EmptyWishlistScreen extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const EmptyWishlistScreen({
    super.key,
    this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 90,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                "Your wishlist is empty",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Save products you like to buy later.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: onContinueShopping,
                child: const Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}