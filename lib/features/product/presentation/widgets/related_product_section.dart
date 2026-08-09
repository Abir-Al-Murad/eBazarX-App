import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RelatedProductsSection extends StatelessWidget {
  final String productId;

  const RelatedProductsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Assume we have a provider for related products
    // For demo, we use dummy data
    final relatedProducts = [
      {'id': '2', 'name': 'Wireless Earbuds', 'price': 99.99, 'image': ''},
      {'id': '3', 'name': 'Smart Watch', 'price': 199.99, 'image': ''},
      {'id': '4', 'name': 'Bluetooth Speaker', 'price': 149.99, 'image': ''},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Products',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return GestureDetector(
                onTap: () {
                  context.push('/product/${product['id']}');
                },
                child: Card(
                  margin: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['name']!.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${product['price']}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}