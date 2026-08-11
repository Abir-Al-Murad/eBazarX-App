import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomActionBar extends StatelessWidget {
  final String productId;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final String variantId;

  const BottomActionBar({
    super.key,
    required this.productId,
    required this.onAddToCart,
    required this.variantId,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final isInWishList = ref.watch(wishNotifierProvider).isInWishlist(variantId);
                return IconButton(
                  onPressed: () {
                    if(AuthStorage.accessToken == null){
                      AppSnackBar.info(context: context,"Please login to add to wishlist");
                      return;
                    }
                    ref.read(wishNotifierProvider.notifier).toggleWishlist(variantId: variantId);
                  },
                  icon: Icon( isInWishList? Icons.favorite : Icons.favorite_border,color: isInWishList? Colors.red : Colors.grey,),
                );
              },

            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}