import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/go_to_login.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/cart/presentation/screens/cart_screen.dart';
import 'package:ebazarx/features/cart/presentation/widgets/cart_summary_bar.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_providers.dart';
import '../widgets/cart_list.dart';
import '../widgets/empty_cart_widget.dart';
import '../widgets/cart_loading_widget.dart';
import '../widgets/cart_error_widget.dart';
import '../widgets/price_summary_card.dart';
import '../widgets/checkout_button.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartNotifierProvider.notifier).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartNotifierProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Cart'),
      //   actions: [
      //     if (state.cart != null && state.cart!.items.isNotEmpty)
      //       IconButton(
      //         onPressed: state.isClearing
      //             ? null
      //             : () => _showClearCartDialog(context),
      //         icon: const Icon(Icons.delete_outline),
      //         tooltip: 'Clear cart',
      //       ),
      //   ],
      // ),
      body: state.isLoading
          ? const CartLoadingWidget()
          : AuthStorage.accessToken == null
          ? const GoToLogIn(
              label: 'Log in to view your cart.',
              icon: Icons.shopping_cart_outlined,
            )
          : state.failure != null
          ? CartErrorWidget(
              error: state.failure!.message,
              onRetry: () => ref.read(cartNotifierProvider.notifier).refresh(),
            )
          : state.cart == null || state.cart!.items.isEmpty
          ? const EmptyCartWidget()
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.all(context.paddingSizeDefault),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cart", style: Theme.of(context).textTheme.headlineSmall),
                            IconButton(onPressed: () {
                              _showClearCartDialog(context);
                            }, icon: const Icon(Icons.clear))
                          ],
                        )),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          ref.read(cartNotifierProvider.notifier).refresh(),
                      child: CartList(
                        items: state.cart!.items,
                        updatingItemIds: state.updatingItemIds,
                        removingItemIds: state.removingItemIds,
                        onUpdateQuantity: (itemId, quantity) {
                          ref
                              .read(cartNotifierProvider.notifier)
                              .updateCartItem(
                                itemId: itemId,
                                quantity: quantity,
                              );
                        },
                        onRemove: (itemId) async {
                          await ref
                              .read(cartNotifierProvider.notifier)
                              .removeCartItem(itemId);
                        },
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextFormField(
                  //           decoration: InputDecoration(
                  //             hintText: 'Enter coupon code',
                  //             prefixIcon: const Icon(Icons.local_offer_outlined),
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //             isDense: true,
                  //           ),
                  //           textCapitalization: TextCapitalization.characters,
                  //           onChanged: (value) {
                  //             // Save locally or in notifier if needed
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(width: 12),
                  //       FilledButton(
                  //         onPressed: () {
                  //           // Validate / Apply Coupon
                  //         },
                  //         child: const Text('Apply'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  CartSummaryBar(
                    subtotal: state.cart!.subtotal,
                    totalItems: state.cart!.totalItems,
                    onCheckout: () {
                      final checkoutItems = state.cart!.items
                          .map(
                            (e) => CheckoutItemEntity(
                              variant_id: e.variantId,
                              quantity: e.quantity,
                            ),
                          )
                          .toList();
                      // Navigate to checkout screen with checkoutItems
                      context.pushNamed(
                        AppRoutesName.checkout,
                        extra: {
                          "items": checkoutItems,
                          "fromCart": true,
                          'subTotal': state.cart!.subtotal,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showClearCartDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(cartNotifierProvider.notifier).clearCart();
    }
  }
}
