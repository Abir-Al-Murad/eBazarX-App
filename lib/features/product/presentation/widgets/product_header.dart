import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String name;
  final String? brand;

  const ProductHeader({
    super.key,
    required this.name,
    this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (brand != null)
          Text(
            brand!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}