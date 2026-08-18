import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';

class SellerProductImageGallery extends StatefulWidget {
  final List<ProductImage> images;

  const SellerProductImageGallery({super.key, required this.images});

  @override
  State<SellerProductImageGallery> createState() => _SellerProductImageGalleryState();
}

class _SellerProductImageGalleryState extends State<SellerProductImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      );
    }

    final primaryImage = widget.images.firstWhere((img) => img.isPrimary, orElse: () => widget.images.first);
    final selectedImage = widget.images[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main image with Hero and tap to zoom
        GestureDetector(
          onTap: () => _showFullScreenImage(context, selectedImage.url),
          child: Hero(
            tag: 'product_image_${selectedImage.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                selectedImage.url,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Thumbnails
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final isSelected = index == _selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image.url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image),
                          ),
                        ),
                      ),
                      if (image.isPrimary)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Primary',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: InteractiveViewer(
          child: Image.network(url),
        ),
      ),
    );
  }
}