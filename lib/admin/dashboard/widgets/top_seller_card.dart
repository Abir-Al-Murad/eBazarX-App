import 'package:ebazarx/admin/dashboard/widgets/panel_card.dart';
import 'package:ebazarx/admin/dashboard/widgets/rank_row.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';
import 'package:flutter/material.dart';

class TopSellersCard extends StatelessWidget {
  const TopSellersCard({required this.sellers});

  final List<AdminTopSeller> sellers;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      title: 'Top Sellers',
      child: sellers.isEmpty
          ? const EmptyState(
        title: 'No seller data',
        icon: Icons.store_outlined, message: 'There are no sellers to display at the moment. Please check back later.',
      )
          : Column(
        children: List.generate(sellers.length, (index) {
          final seller = sellers[index];
          return RankRow(
            rank: index + 1,
            title: seller.shopName,
            subtitle: '${seller.totalOrders} orders',
            trailing: '৳${seller.totalRevenue.toStringAsFixed(2)}',
            icon: Icons.store_rounded,
            showDivider: index != sellers.length - 1,
          );
        }),
      ),
    );
  }
}