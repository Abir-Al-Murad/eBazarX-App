import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_profile_entity.dart';

class SellerShopCard extends StatelessWidget {
  final ShopProfile shop;
  final VoidCallback onViewShop;
  final VoidCallback onManageShop;

  const SellerShopCard({
    super.key,
    required this.shop,
    required this.onViewShop,
    required this.onManageShop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 92,
                width: double.infinity,
                child: (shop.banner != null && shop.banner!.isNotEmpty)
                    ? CachedNetworkImage(
                  imageUrl: shop.banner!,
                  fit: BoxFit.cover,
                )
                    : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.85),
                        theme.colorScheme.primary.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: -24,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.cardColor, width: 3),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipOval(
                    child: (shop.logo != null && shop.logo!.isNotEmpty)
                        ? CachedNetworkImage(
                      imageUrl: shop.logo!,
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.storefront_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        shop.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (shop.isVerified)
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
                Text(
                  '@${shop.slug}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (shop.description != null &&
                    shop.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    shop.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.star_rounded,
                      label: shop.rating.toStringAsFixed(1),
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.inventory_2_rounded,
                      label: '${shop.totalProducts} products',
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewShop,
                        child: const Text('View Shop'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: onManageShop,
                        child: const Text('Manage Shop'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}