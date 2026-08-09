import 'package:flutter/material.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';

class SellerOrderPopupMenu extends StatelessWidget {
  final OrderItemEntity order;
  final Function(String) onStatusChange;

  const SellerOrderPopupMenu({
    super.key,
    required this.order,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'view':
          // handled by card tap
            break;
          case 'contact':
          // TODO: contact customer
            break;
          case 'invoice':
          // TODO: print invoice
            break;
          case 'label':
          // TODO: print shipping label
            break;
          case 'copy_id':
          // TODO: copy order ID
            break;
          default:
          // status change
            onStatusChange(value);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('View Details')),
        const PopupMenuItem(value: 'contact', child: Text('Contact Customer')),
        const PopupMenuItem(value: 'invoice', child: Text('Print Invoice')),
        const PopupMenuItem(value: 'label', child: Text('Print Shipping Label')),
        const PopupMenuItem(value: 'copy_id', child: Text('Copy Order ID')),
        // We can also add status shortcuts
        const PopupMenuItem(value: 'processing', child: Text('Mark Processing')),
        const PopupMenuItem(value: 'shipped', child: Text('Mark Shipped')),
        const PopupMenuItem(value: 'delivered', child: Text('Mark Delivered')),
        const PopupMenuItem(value: 'cancelled', child: Text('Cancel Order')),
      ],
    );
  }
}