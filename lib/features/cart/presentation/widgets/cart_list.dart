import 'package:ebazarx/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';
import 'cart_item_card.dart';

class CartList extends StatelessWidget {
  final List<CartItemEntity> items;
  final Set<String> updatingItemIds;
  final Set<String> removingItemIds;
  final Function(String, int) onUpdateQuantity;
  final Function(String) onRemove;

  const CartList({
    super.key,
    required this.items,
    required this.updatingItemIds,
    required this.removingItemIds,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isRemoving = removingItemIds.contains(item.id);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isRemoving
              ? const SizedBox.shrink()
              : Padding(
            key: ValueKey(item.id),
            padding: const EdgeInsets.only(bottom: 12),
            child: CartItemCard(
              item: item,
              isUpdating: updatingItemIds.contains(item.id),
              onUpdateQuantity: (quantity) =>
                  onUpdateQuantity(item.id, quantity),
              onRemove: () => onRemove(item.id),
            ),
          ),
        );
      },
    );
  }
}