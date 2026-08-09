import 'package:flutter/material.dart';

class StockStatus extends StatelessWidget {
  final int stock;

  const StockStatus({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isInStock = stock > 0;
    final statusText = isInStock ? 'In Stock' : 'Out of Stock';
    final color = isInStock ? Colors.green : Colors.red;

    return Row(
      children: [
        Icon(
          isInStock ? Icons.check_circle : Icons.cancel,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isInStock) ...[
          const SizedBox(width: 8),
          Text(
            '($stock units available)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}