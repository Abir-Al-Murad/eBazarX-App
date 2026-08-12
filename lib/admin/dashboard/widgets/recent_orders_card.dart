

import 'package:ebazarx/common/utils/status_color.dart';
import 'package:ebazarx/common/utils/time_ago.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecentOrdersCard extends StatelessWidget {
  const RecentOrdersCard({super.key, required this.orders, this.onOrderTap, this.onViewAll});

  final List<AdminRecentOrder> orders;
  final ValueChanged<AdminRecentOrder>? onOrderTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.paddingSizeLarge,
              context.paddingSizeLarge,
              context.paddingSizeDefault,
              context.paddingSizeSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      'View all',
                      style: TextStyle(fontSize: context.fontSizeSmall),
                    ),
                  ),
              ],
            ),
          ),
          if (orders.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.paddingSizeExtraLarge),
              child: Center(
                child: Text(
                  'No recent orders',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: theme.dividerColor,
                indent: context.paddingSizeLarge,
                endIndent: context.paddingSizeLarge,
              ),
              itemBuilder: (context, index) => _OrderRow(
                order: orders[index],
                onTap: onOrderTap == null ? null : () => onOrderTap!(orders[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, this.onTap});

  final AdminRecentOrder order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stColor = statusColor(order.orderStatus);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingSizeLarge,
          vertical: context.paddingSizeSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: stColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(context.radiusDefault),
              ),
              child: Icon(Icons.receipt_long_rounded, color: stColor, size: 20),
            ),
            SizedBox(width: context.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.orderNumber.isNotEmpty
                            ? '#${order.orderNumber}'
                            : '#${order.id.substring(0, 8).toUpperCase()}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: (){
                        Clipboard.setData(ClipboardData(text: order.orderNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order number copied to clipboard'),
                          ),
                        );
                      }, icon: Icon(Icons.copy))
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    order.customerName ?? 'Guest Customer',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  StatusChip(status: order.orderStatus, showDot: false),
                ],
              ),
            ),
            SizedBox(width: context.paddingSizeSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳${order.grandTotal.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  timeAgo(order.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}