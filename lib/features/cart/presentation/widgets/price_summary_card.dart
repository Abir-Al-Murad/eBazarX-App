import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PriceSummaryCard extends StatefulWidget {
  final double subtotal;
  final int totalItems;

  const PriceSummaryCard({
    super.key,
    required this.subtotal,
    required this.totalItems,
  });

  @override
  State<PriceSummaryCard> createState() => _PriceSummaryCardState();
}

class _PriceSummaryCardState extends State<PriceSummaryCard> {
  double _displayedSubtotal = 0;

  @override
  void initState() {
    _displayedSubtotal = widget.subtotal;
    super.initState();
  }

  @override
  void didUpdateWidget(PriceSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subtotal != widget.subtotal) {
      setState(() {
        _displayedSubtotal = widget.subtotal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${widget.totalItems} items)',
                  style: theme.textTheme.bodyMedium,
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    '\$${_displayedSubtotal.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // We'll add more rows later (discount, shipping, tax)
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  child: Text(
                    '\$${_displayedSubtotal.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}