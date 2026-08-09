import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = const Color(0xFF22C55E).withOpacity(0.1);
        textColor = const Color(0xFF22C55E);
        break;
      case 'pending':
        bgColor = const Color(0xFF8B5CF6).withOpacity(0.1);
        textColor = const Color(0xFF8B5CF6);
        break;
      case 'draft':
        bgColor = const Color(0xFFF59E0B).withOpacity(0.1);
        textColor = const Color(0xFFF59E0B);
        break;
      case 'rejected':
        bgColor = const Color(0xFFEF4444).withOpacity(0.1);
        textColor = const Color(0xFFEF4444);
        break;
      case 'archived':
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        break;
      case 'out of stock':
        bgColor = const Color(0xFFF97316).withOpacity(0.1);
        textColor = const Color(0xFFF97316);
        break;
      default:
        bgColor = theme.colorScheme.primary.withOpacity(0.1);
        textColor = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}