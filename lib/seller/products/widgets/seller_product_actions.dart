import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/seller/products/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:go_router/go_router.dart';

class SellerProductActions extends StatelessWidget {
  final Product product;

  const SellerProductActions({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(AppRoutesName.addEditProduct, extra: product);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // Duplicate logic
              },
              icon: const Icon(Icons.copy),
              label: const Text('Duplicate'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // Archive logic
              },
              icon: const Icon(Icons.archive),
              label: const Text('Archive'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // Delete with confirmation
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}