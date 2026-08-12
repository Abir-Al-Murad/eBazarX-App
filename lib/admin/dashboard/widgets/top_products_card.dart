import 'package:ebazarx/admin/dashboard/widgets/panel_card.dart';
import 'package:ebazarx/admin/dashboard/widgets/rank_row.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:flutter/material.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key, required this.products});

  final List<AdminTopProduct> products;

  @override
  Widget build(BuildContext context) {

    return PanelCard(
      title: 'Top Products',
      child: products.isEmpty
          ? const EmptyState(
        message: "There are no products to display at the moment.",
        icon: Icons.inventory_2_outlined, title: 'No Products',
      )
          : Column(
        children: List.generate(products.length, (index) {
          final product = products[index];
          return RankRow(
            rank: index + 1,
            title: product.productName,
            subtitle: '${product.totalSales} sales',
            trailing: '৳${product.revenue.toStringAsFixed(2)}',
            icon: Icons.inventory_2_rounded,
            showDivider: index != products.length - 1,
          );
        }),
      ),
    );
  }
}