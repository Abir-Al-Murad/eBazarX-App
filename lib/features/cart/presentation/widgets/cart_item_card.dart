import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

import 'quantity_selector.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final bool isUpdating;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isUpdating,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: context.paddingSizeSmall),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onRemove(),
        // Glassmorphic Swipe-to-Delete Background
        background: ClipRRect(
          borderRadius: BorderRadius.circular(context.radiusDefault),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(isDark ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(context.radiusDefault),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Remove",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Glassmorphic Card Container
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.radiusDefault),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                padding: EdgeInsets.all(context.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.white.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(context.radiusDefault),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.12)
                        : Colors.white.withOpacity(0.65),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Glass Product Image Wrapper
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
                        child: Hero(
                          tag: 'cart_${item.productId}',
                          child: CachedNetworkImage(
                            imageUrl: item.productImage ?? '',
                            width: context.responsive(mobile: 80.0, tablet: 96.0),
                            height: context.responsive(mobile: 80.0, tablet: 96.0),
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
                    ),
                    SizedBox(width: context.paddingSizeDefault),

                    // Product Details & Quantity Controls
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Loading State Indicator
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.productName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: context.fontSizeDefault,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isUpdating)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Glass Attribute Pills
                          if (item.variantAttributes != null &&
                              item.variantAttributes!.isNotEmpty) ...[
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children:
                              item.variantAttributes!.entries.map((e) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: colorScheme.primary
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    '${e.key}: ${e.value}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontSize: context.fontSizeExtraSmall,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 6),
                          ],

                          // Unit Price Display
                          Text(
                            'Unit: ৳${item.price.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant
                                  .withOpacity(0.8),
                              fontSize: context.fontSizeExtraSmall,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Bottom Controls: Quantity Selector & Total Price
                          Row(
                            children: [
                              QuantitySelector(
                                quantity: item.quantity,
                                onIncrement: () =>
                                    onUpdateQuantity(item.quantity + 1),
                                onDecrement: () =>
                                    onUpdateQuantity(item.quantity - 1),
                                isUpdating: isUpdating,
                              ),
                              const Spacer(),
                              Text(
                                '৳${item.total.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                  fontSize: context.fontSizeLarge,
                                ),
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
    );
  }
}