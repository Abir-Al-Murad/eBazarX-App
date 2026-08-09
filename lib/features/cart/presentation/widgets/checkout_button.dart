import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutButton extends StatelessWidget {
  final List<CheckoutItemEntity> items;

  const CheckoutButton({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Continue Shopping"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  AppRoutesName.checkout,
                  extra: {"items": items, "fromCart": true},
                );
              },
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}