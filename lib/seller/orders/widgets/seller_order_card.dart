import 'package:flutter/material.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_status_chip.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_status_dropdown.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_popup_menu.dart';

class SellerOrderCard extends StatelessWidget {
  final OrderItemEntity order;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onTap;
  final Function(String) onStatusChange;
  final bool isUpdating;

  const SellerOrderCard({
    super.key,
    required this.order,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onTap,
    required this.onStatusChange,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onToggleSelection(),
                    ),
                    Expanded(
                      child: Text(
                        'Order #${order.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isUpdating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      SellerOrderStatusDropdown(
                        currentStatus: order.status,
                        onChanged: onStatusChange,
                      ),
                    SellerOrderPopupMenu(
                      order: order,
                      onStatusChange: onStatusChange,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.productImageAtTime != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.productImageAtTime!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productNameAtTime,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text('Price: \$${order.priceAtTime.toStringAsFixed(2)}'),
                          Text('Qty: ${order.quantity}'),
                          if (order.sizeAtTime != null) Text('Size: ${order.sizeAtTime}'),
                          if (order.colorAtTime != null) Text('Color: ${order.colorAtTime}'),
                          const SizedBox(height: 4),
                          SellerOrderStatusChip(status: order.status),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}