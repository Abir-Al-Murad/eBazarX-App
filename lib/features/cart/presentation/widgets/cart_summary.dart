import 'dart:ui';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartBottomSummary extends StatelessWidget {
  final double subtotal;
  final int totalItems;
  final List<CheckoutItemEntity> items;
  final double bottomNavBarHeight; // Set to fit your bottom nav height (default: 65)

  const CartBottomSummary({
    super.key,
    required this.subtotal,
    required this.totalItems,
    required this.items,
    this.bottomNavBarHeight = 65.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(
        left: context.paddingSizeDefault,
        right: context.paddingSizeDefault,
        top: context.paddingSizeSmall,
        bottom: bottomNavBarHeight + context.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radiusExtraLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.radiusExtraLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.all(context.paddingSizeDefault),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(context.radiusExtraLarge),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtotal Row with Item Count Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Subtotal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: context.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalItems ${totalItems == 1 ? 'item' : 'items'}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: context.fontSizeExtraSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _AnimatedPriceText(
                      value: subtotal,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: context.fontSizeDefault,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Glass Divider Line
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        isDark
                            ? Colors.white.withOpacity(0.15)
                            : colorScheme.outlineVariant.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Grand Total Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: context.fontSizeLarge,
                      ),
                    ),
                    _AnimatedPriceText(
                      value: subtotal,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: context.fontSizeExtraLarge,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.paddingSizeDefault),

                // Dual Action Buttons
                Row(
                  children: [
                    // Continue Shopping Button
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : colorScheme.outline.withOpacity(0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(context.radiusDefault),
                          ),
                        ),
                        child: Text(
                          "Shop More",
                          style: TextStyle(
                            fontSize: context.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Primary Checkout Button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: items.isEmpty
                            ? null
                            : () {
                          context.pushNamed(
                            AppRoutesName.checkout,
                            extra: {"items": items, "fromCart": true},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                          colorScheme.primary.withOpacity(0.85),
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(context.radiusDefault),
                          ),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 18,
                        ),
                        label: Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: context.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Smooth Implicit Price Counter Animation
class _AnimatedPriceText extends StatelessWidget {
  final double value;
  final TextStyle? style;

  const _AnimatedPriceText({
    required this.value,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: value, end: value),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) {
        return Text(
          '৳${animatedValue.toStringAsFixed(2)}',
          style: style,
        );
      },
    );
  }
}