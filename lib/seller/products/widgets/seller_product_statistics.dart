import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductStatistics extends StatelessWidget {
  final Product product;

  const SellerProductStatistics({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            StatCard(title: 'Sales', value: product.totalSales.toString(), color: Colors.blue, icon: Icons.shopping_cart),
            StatCard(title: 'Revenue', value: '\$${(product.totalSales * product.effectivePrice).toStringAsFixed(0)}', color: Colors.green, icon: Icons.attach_money),
            StatCard(title: 'Rating', value: product.averageRating.toStringAsFixed(1), color: Colors.orange, icon: Icons.star),
            StatCard(title: 'Reviews', value: product.totalReviews.toString(), color: Colors.purple, icon: Icons.comment),
            StatCard(title: 'Stock', value: product.variants.fold<int>(0, (sum, v) => sum + v.stock).toString(), color: Colors.teal, icon: Icons.inventory),
            StatCard(title: 'Variants', value: product.variants.length.toString(), color: Colors.indigo, icon: Icons.list_alt),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}