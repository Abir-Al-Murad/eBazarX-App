import 'package:flutter/material.dart';

class PriceSection extends StatelessWidget {
  final double currentPrice;
  final double oldPrice;
  final int discountPercent;

  const PriceSection({
    super.key,
    required this.currentPrice,
    required this.oldPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    final currency = '৳'; // Or your currency symbol

    return Row(
      children: [
        Text(
          '$currency${currentPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$currency${oldPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '-${discountPercent}%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}