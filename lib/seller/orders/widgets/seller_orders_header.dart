import 'package:flutter/material.dart';

class SellerOrdersHeader extends StatelessWidget {
  const SellerOrdersHeader({super.key,required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.shopping_bag_outlined, size: 28),
        const SizedBox(width: 8),
        Text('Seller Orders', style: Theme.of(context).textTheme.headlineMedium),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onPressed
        ),
      ],
    );
  }
}