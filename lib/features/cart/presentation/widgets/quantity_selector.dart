import 'dart:async';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final int minQuantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isUpdating;
  final Duration debounceDuration;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.minQuantity = 1,
    this.isUpdating = false,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _localQuantity;
  Timer? _debounce;
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    _localQuantity = widget.quantity;
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync from parent when there's no pending debounced change,
    // otherwise it'll overwrite the optimistic local value mid-debounce.
    if (!_pending && widget.quantity != oldWidget.quantity) {
      _localQuantity = widget.quantity;
    }
  }

  void _bump(int delta) {
    if (widget.isUpdating) return;
    final next = _localQuantity + delta;
    if (next < widget.minQuantity) return;

    setState(() {
      _localQuantity = next;
      _pending = true;
    });

    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      _pending = false;
      widget.onQuantityChanged(_localQuantity);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(context.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context: context,
            icon: Icons.remove,
            onTap: _localQuantity > widget.minQuantity ? () => _bump(-1) : null,
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: widget.isUpdating
                ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            )
                : Text(
              _localQuantity.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildButton(
            context: context,
            icon: Icons.add,
            onTap: () => _bump(1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: onTap == null
              ? theme.colorScheme.surfaceContainerHighest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.radiusSmall),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}