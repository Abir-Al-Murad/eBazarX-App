import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:flutter/material.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';

class SellerStatisticsCards extends StatelessWidget {
  final List<OrderItemEntity> orders;

  const SellerStatisticsCards({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final total = orders.length;
    final pending = orders.where((o) => o.status == OrderStatus.pending).length;
    final processing = orders.where((o) => o.status == OrderStatus.processing).length;
    final shipped = orders.where((o) => o.status == OrderStatus.shipped).length;
    final delivered = orders.where((o) => o.status == OrderStatus.delivered).length;
    final cancelled = orders.where((o) => o.status == OrderStatus.cancelled).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            StatCard(title: 'Total', value: total.toString(), color: Colors.blue, icon: Icons.shopping_cart),
            StatCard(title: 'Pending', value: pending.toString(), color: Colors.orange, icon: Icons.hourglass_empty),
            StatCard(title: 'Processing', value: processing.toString(), color: Colors.blue, icon: Icons.production_quantity_limits),
            StatCard(title: 'Shipped', value: shipped.toString(), color: Colors.teal, icon: Icons.local_shipping),
            StatCard(title: 'Delivered', value: delivered.toString(), color: Colors.green, icon: Icons.check_circle),
            StatCard(title: 'Cancelled', value: cancelled.toString(), color: Colors.red, icon: Icons.cancel),
          ],
        );
      },
    );
  }
}