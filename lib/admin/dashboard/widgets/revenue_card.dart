
import 'package:ebazarx/admin/dashboard/widgets/panel_card.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:flutter/material.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key, required this.revenue});

  final List<AdminRevenue> revenue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxRevenue = revenue.isEmpty
        ? 1.0
        : revenue.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);

    return PanelCard(
      title: 'Revenue Overview',
      subtitle: 'Revenue and orders for the selected period',
      child: revenue.isEmpty
          ? const EmptyState(
        message: 'No revenue data available',
        icon: Icons.bar_chart_rounded, title: 'Revenue Overview',
      )
          : SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: revenue.length,
          separatorBuilder: (_, __) =>
              SizedBox(width: context.paddingSizeSmall),
          itemBuilder: (context, index) {
            final item = revenue[index];
            final barHeight = maxRevenue == 0
                ? 0.0
                : (item.revenue / maxRevenue) * 90;

            return Container(
              width: 120,
              padding: EdgeInsets.all(context.paddingSizeSmall + 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  context.radiusDefault,
                ),
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.06,
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '৳${item.revenue.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.paddingSizeSmall),
                  Container(
                    height: barHeight.clamp(6, 90),
                    width: 28,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  SizedBox(height: context.paddingSizeSmall),
                  Text(
                    item.period,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${item.orders} orders',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}