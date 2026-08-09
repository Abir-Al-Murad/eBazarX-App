import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductImageCarousel extends ConsumerStatefulWidget {
  final List<ProductImage> images;

  /// Nullable — a product may momentarily (or permanently, if it has no
  /// variants) have no selected variant. The wishlist toggle simply hides
  /// itself in that case instead of crashing.
  final String? variantId;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.variantId,
  });

  @override
  ConsumerState<ProductImageCarousel> createState() =>
      _ProductImageCarouselState();
}

class _ProductImageCarouselState extends ConsumerState<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final variantId = widget.variantId;
    final wishState = ref.watch(wishNotifierProvider);

    return Stack(
      children: [
        CarouselSlider(
          items: widget.images.map((image) {
            return GestureDetector(
              child: Hero(
                tag: image.id,
                child: CachedNetworkImage(
                  imageUrl: image.url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            enlargeCenterPage: false,
            height: double.infinity,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _currentIndex == index ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white70,
                ),
              ),
            ),
          ),
        ),

        // Only show the wishlist toggle once we actually have a variant
        // to act on — nothing to add/remove from the wishlist otherwise.
        // if (variantId != null)
          // Positioned(
          //   top: 12,
          //   right: 12,
          //   child: CircleAvatar(
          //     backgroundColor: Colors.white.withOpacity(.9),
          //     child: IconButton(
          //       onPressed: () {
          //         ref
          //             .read(wishNotifierProvider.notifier)
          //             .toggleWishlist(variantId: variantId);
          //       },
          //       icon: wishState.addingVariantIds.contains(variantId)
          //           ? const SizedBox(
          //         width: 18,
          //         height: 18,
          //         child: CircularProgressIndicator(strokeWidth: 2),
          //       )
          //           : Icon(
          //         wishState.isInWishlist(variantId)
          //             ? Icons.favorite
          //             : Icons.favorite_border,
          //         color: wishState.isInWishlist(variantId)
          //             ? Colors.red
          //             : Colors.grey.shade700,
          //       ),
          //     ),
          //   ),
          // ),
      ],
    );
  }
}