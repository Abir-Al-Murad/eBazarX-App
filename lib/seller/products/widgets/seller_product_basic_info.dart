import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductBasicInfo extends StatelessWidget {
  final Product product;

  const SellerProductBasicInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(product.isActive),
                const SizedBox(width: 8),
                _buildApprovalChip(product.approvalStatus),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${product.categoryId}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (product.brandId != null)
              Text('Brand: ${product.brandId}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('SKU: ${product.sku}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Slug: ${product.slug}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    final color = isActive ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? Icons.check_circle : Icons.cancel, size: 14, color: color),
          const SizedBox(width: 4),
          Text(isActive ? 'Active' : 'Inactive', style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildApprovalChip(String status) {
    Color color;
    IconData icon;
    if (status == 'approved') {
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (status == 'pending') {
      color = Colors.orange;
      icon = Icons.hourglass_empty;
    } else {
      color = Colors.red;
      icon = Icons.cancel;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}