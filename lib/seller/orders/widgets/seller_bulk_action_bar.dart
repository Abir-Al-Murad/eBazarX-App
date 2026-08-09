import 'package:flutter/material.dart';

class SellerBulkActionBar extends StatelessWidget {
  final Set<String> selectedIds;
  final VoidCallback onClearSelection;
  final VoidCallback onSelectAll;
  final Function(String) onBulkStatusUpdate;

  const SellerBulkActionBar({
    super.key,
    required this.selectedIds,
    required this.onClearSelection,
    required this.onSelectAll,
    required this.onBulkStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: onSelectAll,
            tooltip: 'Select All / Clear All',
          ),
          const SizedBox(width: 8),
          Text('${selectedIds.length} selected'),
          const Spacer(),
          _buildActionButton(context, 'Processing', Icons.production_quantity_limits, () => onBulkStatusUpdate('processing')),
          _buildActionButton(context, 'Packed', Icons.inventory, () => onBulkStatusUpdate('packed')),
          _buildActionButton(context, 'Shipped', Icons.local_shipping, () => onBulkStatusUpdate('shipped')),
          _buildActionButton(context, 'Delivered', Icons.check_circle, () => onBulkStatusUpdate('delivered')),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {}, // Export CSV
            tooltip: 'Export CSV',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClearSelection,
            tooltip: 'Clear Selection',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Tooltip(
      message: label,
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}