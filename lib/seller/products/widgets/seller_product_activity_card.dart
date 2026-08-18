import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductActivityCard extends StatelessWidget {
  final Product product;

  const SellerProductActivityCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _infoRow('Created At', product.createdAt?.toLocal().toString() ?? 'N/A'),
            _infoRow('Updated At', product.updatedAt?.toLocal().toString() ?? 'N/A'),
            const Divider(),
            _infoRow('Product ID', product.id),
            _infoRow('Seller ID', product.sellerId),
            _infoRow('Category ID', product.categoryId),
            if (product.brandId != null) _infoRow('Brand ID', product.brandId!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}