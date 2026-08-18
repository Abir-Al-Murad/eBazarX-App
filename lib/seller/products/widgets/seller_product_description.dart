import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductDescription extends StatelessWidget {
  final Product product;

  const SellerProductDescription({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (product.description != null)
              Text(product.description!, style: Theme.of(context).textTheme.bodyMedium)
            else
              const Text('No description provided.'),
            const SizedBox(height: 16),
            if (product.seoTitle != null || product.seoDescription != null || product.metaKeywords != null) ...[
              Text('SEO', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              if (product.seoTitle != null)
                Text('Title: ${product.seoTitle}', style: Theme.of(context).textTheme.bodySmall),
              if (product.seoDescription != null)
                Text('Description: ${product.seoDescription}', style: Theme.of(context).textTheme.bodySmall),
              if (product.metaKeywords != null)
                Text('Keywords: ${product.metaKeywords}', style: Theme.of(context).textTheme.bodySmall),
            ],
            if (product.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: product.tags.map((tag) => Chip(label: Text(tag), backgroundColor: Colors.grey[200])).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}