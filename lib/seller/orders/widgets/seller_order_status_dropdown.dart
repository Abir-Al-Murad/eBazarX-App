import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:flutter/material.dart';

class SellerOrderStatusDropdown extends StatelessWidget {
  final OrderStatus currentStatus;
  final Function(String) onChanged;

  const SellerOrderStatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentStatus.name,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (newStatusName) {
        if (newStatusName != null && newStatusName != currentStatus.name) {
          onChanged(newStatusName);
        }
      },
      items: OrderStatus.values.map((status) {
        return DropdownMenuItem(
          value: status.name,
          child: Text(status.name.toUpperCase()),
        );
      }).toList(),
    );
  }
}