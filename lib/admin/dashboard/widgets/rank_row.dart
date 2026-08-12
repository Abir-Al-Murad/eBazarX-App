import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RankRow extends StatelessWidget {
  const RankRow({super.key,
    required this.rank,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    required this.showDivider,
  });

  final int rank;
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTopThree = rank <= 3;
    final badgeColor = isTopThree
        ? AppColors.warning
        : theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeSmall),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: badgeColor.withValues(alpha: 0.12),
                child: Text(
                  '$rank',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              SizedBox(width: context.paddingSizeSmall),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.radiusDefault),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: context.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                trailing,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: theme.dividerColor),
      ],
    );
  }
}
