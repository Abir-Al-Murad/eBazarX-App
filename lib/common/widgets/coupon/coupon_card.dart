
import 'package:ebazarx/common/widgets/coupon/coupon_action_menu.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Coupon card for mobile/tablet grids — shared by admin + seller
/// coupon screens. Takes plain fields rather than an entity type so
/// it works regardless of which module's coupon model calls it.
class CouponCard extends StatelessWidget {
  const CouponCard({
    super.key,
    required this.code,
    required this.discountText,
    required this.startDate,
    required this.endDate,
    required this.usedCount,
    required this.usageLimit,
    required this.isActive,
    required this.onEdit,
    required this.onDelete,
  });

  final String code;
  final String discountText;
  final DateTime startDate;
  final DateTime endDate;
  final int usedCount;
  final int? usageLimit;
  final bool isActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.paddingSizeSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.radiusSmall),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  StatusChip(status: isActive ? 'Active' : 'Inactive', showDot: false),
                  CouponActionsMenu(onEdit: onEdit, onDelete: onDelete, compact: true),
                ],
              ),
              SizedBox(height: context.paddingSizeSmall),
              Text(
                discountText,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: context.paddingSizeExtraSmall),
              Text(
                'Valid: ${dateFormat.format(startDate)} → ${dateFormat.format(endDate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Used: $usedCount / ${usageLimit ?? "∞"}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}