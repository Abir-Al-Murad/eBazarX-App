import 'package:flutter/material.dart';

class CouponStatusChip extends StatelessWidget {
  final bool isActive;
  final bool isExpired;

  const CouponStatusChip({
    super.key,
    required this.isActive,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String label;
    Color color;

    if (isExpired) {
      label = 'Expired';
      color = Colors.grey;
    } else if (isActive) {
      label = 'Active';
      color = Colors.green;
    } else {
      label = 'Inactive';
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}