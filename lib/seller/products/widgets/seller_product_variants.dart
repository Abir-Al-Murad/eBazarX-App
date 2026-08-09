import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';

class SellerProductVariants extends StatelessWidget {
  final List<ProductVariant> variants;

  const SellerProductVariants({super.key, required this.variants});

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Variants (${variants.length})', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('SKU')),
                  DataColumn(label: Text('Attributes')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Status')),
                ],
                rows: variants.map((variant) {
                  final stock = variant.stock - variant.reservedStock;
                  final isLowStock = stock <= 5;
                  return DataRow(
                    cells: [
                      DataCell(Text(variant.sku)),
                      DataCell(Text(variant.attributes.entries.map((e) => '${e.key}: ${e.value}').join(', '))),
                      DataCell(Text(variant.priceOverride != null ? '\$${variant.priceOverride!.toStringAsFixed(2)}' : 'Base')),
                      DataCell(
                        Text(
                          stock.toString(),
                          style: TextStyle(
                            color: isLowStock ? Colors.red : null,
                            fontWeight: isLowStock ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isLowStock ? Colors.red.withOpacity(0.15) : Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isLowStock ? 'Low Stock' : 'In Stock',
                            style: TextStyle(color: isLowStock ? Colors.red : Colors.green, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}