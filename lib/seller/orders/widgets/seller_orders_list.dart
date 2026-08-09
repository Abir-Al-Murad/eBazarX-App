import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_card.dart';

class SellerOrdersList extends StatelessWidget {
  final List<OrderItemEntity> orders;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(OrderItemEntity) onOrderTap;
  final Function(String, String) onStatusChange;
  final Set<String> updatingIds;

  const SellerOrdersList({
    super.key,
    required this.orders,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onOrderTap,
    required this.onStatusChange,
    required this.updatingIds,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width < 900;
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    if (isDesktop) {
      return _buildDesktopTable(context);
    } else {
      return _buildGrid(context, crossAxisCount: isTablet ? 2 : 1);
    }
  }

  Widget _buildGrid(BuildContext context, {int crossAxisCount = 1}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: crossAxisCount == 1 ? 0.85 : 1.0,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return SellerOrderCard(
          order: order,
          isSelected: selectedIds.contains(order.id),
          onToggleSelection: () => onToggleSelection(order.id),
          onTap: () => onOrderTap(order),
          onStatusChange: (status) => onStatusChange(order.id, status),
          isUpdating: updatingIds.contains(order.id),
        );
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 50,
          dataRowMaxHeight: 80,
          columns: const [
            // DataColumn(label: Text('Select')),
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.map((order) {
            return DataRow(
              selected: selectedIds.contains(order.id),
              onSelectChanged: (_) => onToggleSelection(order.id),
              cells: [
                // DataCell(Checkbox(
                //   value: selectedIds.contains(order.id),
                //   onChanged: (_) => onToggleSelection(order.id),
                // )),
                DataCell(Row(
                  children: [
                    if (order.productImageAtTime != null)
                      Image.network(order.productImageAtTime!, width: 40, height: 40),
                    const SizedBox(width: 8),
                    Expanded(child: Text(order.productNameAtTime)),
                  ],
                )),
                DataCell(Text('\$${order.priceAtTime.toStringAsFixed(2)}')),
                DataCell(Text('${order.quantity}')),
                DataCell(_statusChip(order.status)),
                DataCell(
                  SellerOrderPopupMenu(
                    order: order,
                    onStatusChange: (status) => onStatusChange(order.id, status),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(_statusDisplayName(status), style: TextStyle(color: color)),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.processing: return Colors.blue;
      case OrderStatus.shipped: return Colors.teal;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
      default: return Colors.grey;
    }
  }

  String _statusDisplayName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
      default: return status.name;
    }
  }
}