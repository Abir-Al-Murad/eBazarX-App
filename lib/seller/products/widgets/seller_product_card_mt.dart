import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class SellerProductCardMT extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SellerProductCardMT({super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  int _totalStock(Product p) {
    return p.variants.fold(0, (sum, v) => sum + v.stock);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final stock = _totalStock(product);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: product.primaryImage?.url != null
                        ? CachedNetworkImage(
                      imageUrl: product.primaryImage!.url,
                    )
                        : const Icon(Icons.image_rounded, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'SKU: ${product.sku}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '৳${product.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(width: 8),
                            if (product.discountPrice != null &&
                                product.hasDiscount)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${product.discountPercent}%',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.totalSales} sold',
                              style: theme.textTheme.labelSmall,
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$stock in stock',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: product.approvalStatus),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _actionChip(
                    context,
                    icon: Icons.visibility_rounded,
                    label: 'Preview',
                    onPressed: onTap,
                  ),
                  _actionChip(
                    context,
                    icon: Icons.edit_rounded,
                    label: 'Edit',
                    onPressed: onEdit,
                  ),
                  _actionChip(
                    context,
                    icon: Icons.delete_rounded,
                    label: 'Delete',
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
        Color? color,
      }) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color ?? theme.colorScheme.primary),
      label: Text(
        label,
        style: TextStyle(
          color: color ?? theme.colorScheme.primary,
          fontSize: 12,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}