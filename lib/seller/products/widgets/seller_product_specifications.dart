import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductSpecifications extends StatelessWidget {
  final Product product;

  const SellerProductSpecifications({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasSpecs = product.weight != null || product.dimensions != null;
    if (!hasSpecs) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specifications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (product.weight != null)
                  _SpecChip(label: 'Weight', value: '${product.weight} ${product.dimensions?.unit ?? 'kg'}'),
                if (product.dimensions != null) ...[
                  _SpecChip(label: 'Length', value: '${product.dimensions!.length} ${product.dimensions!.unit}'),
                  _SpecChip(label: 'Width', value: '${product.dimensions!.width} ${product.dimensions!.unit}'),
                  _SpecChip(label: 'Height', value: '${product.dimensions!.height} ${product.dimensions!.unit}'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const _SpecChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 13)),
    );
  }
}