import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/wish/domain/entities/wish_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Safely parse variant attributes
    final attributes = item.variantAttributes?.entries
        .map((e) => "${e.key}: ${e.value}")
        .join(" • ") ??
        "";

    return InkWell(
      onTap: (){
        context.pushNamed(AppRoutesName.productDetails,pathParameters: {"product_id":item.productId});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.paddingSizeSmall),
        // Outer glass shadow & border radius
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.radiusDefault),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              // Translucent glass fill and rim gradient
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(context.radiusDefault),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.white.withOpacity(0.6),
                  width: 1.2,
                ),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(context.radiusDefault),
                child: Padding(
                  padding: EdgeInsets.all(context.paddingSizeDefault),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glassmorphic Image Container
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(context.radiusSmall),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(context.radiusSmall),
                          child: CachedNetworkImage(
                            imageUrl: item.productImage ?? "",
                            width:
                            context.responsive(mobile: 90.0, tablet: 110.0),
                            height:
                            context.responsive(mobile: 90.0, tablet: 110.0),
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black.withOpacity(0.04),
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black.withOpacity(0.04),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.paddingSizeDefault),

                      // Details Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              item.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: context.fontSizeDefault,
                                height: 1.25,
                              ),
                            ),

                            // Variant Subtitle Pill
                            if (attributes.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: colorScheme.primary.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  attributes,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontSize: context.fontSizeExtraSmall,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],

                            SizedBox(height: context.paddingSizeSmall),

                            // Price & Actions Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Price Text
                                Expanded(
                                  child: Text(
                                    "৳${item.price}",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                      fontSize: context.fontSizeLarge,
                                    ),
                                  ),
                                ),

                                // Glassy Add To Cart Button
                                ElevatedButton.icon(
                                  onPressed: onAddToCart,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                    colorScheme.primary.withOpacity(0.85),
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.radiusSmall,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 15,
                                  ),
                                  label: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      fontSize: context.fontSizeExtraSmall,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),

                                // Glassy Remove Button
                                IconButton(
                                  onPressed: onRemove,
                                  style: IconButton.styleFrom(
                                    foregroundColor: colorScheme.error,
                                    backgroundColor:
                                    colorScheme.error.withOpacity(0.1),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                  ),
                                  tooltip: "Remove",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}