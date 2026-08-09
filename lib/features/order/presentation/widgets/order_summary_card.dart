import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
  });

  Widget _row(String title, String value,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight:
            bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight:
            bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row("Subtotal", "৳$subtotal"),
            const SizedBox(height: 8),
            _row("Shipping", "৳$shipping"),
            const SizedBox(height: 8),
            _row("Tax", "৳$tax"),
            const SizedBox(height: 8),
            _row("Discount", "-৳$discount"),
            const Divider(height: 24),
            _row(
              "Total",
              "৳$total",
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}