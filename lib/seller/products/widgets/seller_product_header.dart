import 'package:flutter/material.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductHeader extends StatelessWidget implements PreferredSizeWidget {
  final Product? product;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onMore;

  const SellerProductHeader({
    super.key,
    required this.product,
    required this.isLoading,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      title: isLoading
          ? Container(
        width: 200,
        height: 20,
        color: Colors.grey[300],
      )
          : Text(product?.name ?? 'Product Details'),
      actions: [
        if (!isLoading) ...[
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEdit,
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            tooltip: 'Delete Product',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: onShare,
            tooltip: 'Share',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle more actions
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
              const PopupMenuItem(value: 'export', child: Text('Export')),
            ],
          ),
        ],
        if (isLoading)
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}