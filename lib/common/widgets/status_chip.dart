import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final bool showDot;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.status,
    this.showDot = true,
    this.onTap,
  });

  Color _colorFor(String status, ThemeData theme) {
    switch (status.trim().toLowerCase()) {
    // Success States (Green)
      case 'active':
      case 'completed':
      case 'delivered':
      case 'paid':
        return AppColors.success;

    // Pending / Awaiting Action (Violet/Indigo)
      case 'pending':
      case 'awaiting payment':
        return AppColors.warning;

    // Processing / In Progress (Amber/Warning)
      case 'processing':
      case 'in_progress':
      case 'preparing':
        return AppColors.pending;

    // Shipped / In Transit (Sky Blue/Teal)
      case 'shipped':
      case 'in_transit':
      case 'out_for_delivery':
        return AppColors.draft; // Uses Sky Blue / Draft color

    // Draft / On Hold
      case 'draft':
      case 'on hold':
        return AppColors.draft;

    // Failed / Errors (Red)
      case 'rejected':
      case 'failed':
      case 'cancelled':
        return AppColors.error;

    // Archived / Returned / Inactive (Slate Grey)
      case 'archived':
      case 'inactive':
      case 'returned':
      case 'refunded':
        return AppColors.archived;

    // Out of Stock (Rose Berry)
      case 'out of stock':
      case 'out_of_stock':
        return AppColors.outOfStock;

      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _colorFor(status, theme);

    final chipContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingSizeSmall + 2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            _StatusDot(color: color),
            SizedBox(width: context.paddingSizeExtraSmall),
          ],
          Text(
            _formatStatusText(status),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: context.fontSizeExtraSmall,
              letterSpacing: 0.5,
              height: 1.1,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return chipContent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radiusLarge),
      child: chipContent,
    );
  }

  String _formatStatusText(String text) {
    return text.replaceAll('_', ' ').toUpperCase();
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;

  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Soft Glow Ring
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.35),
            ),
          ),
          // Inner Solid Core
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 2,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}