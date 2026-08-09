import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/providers/bottom_nav_provider.dart';
import 'package:ebazarx/common/widgets/go_to_login.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:ebazarx/features/wish/presentation/widgets/wishlist_empty.dart';
import 'package:ebazarx/features/wish/presentation/widgets/wishlist_error.dart';
import 'package:ebazarx/features/wish/presentation/widgets/wishlist_item_card.dart';
import 'package:ebazarx/features/wish/presentation/widgets/wishlist_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(wishNotifierProvider.notifier).fetchWishList();
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wishNotifierProvider);

    if (state.isLoading && state.wishlist == null) {
      return const WishlistLoadingScreen();
    }
    if(!AuthStorage.instance.isLoggedIn){
      return GoToLogIn(label: 'Log in to view your wishlist.',icon: Icons.favorite_border_outlined);
    }
    if (state.failure != null && state.wishlist == null) {
      return WishlistErrorScreen(
        message: state.failure!.message,
        onRetry: () {
          ref.read(wishNotifierProvider.notifier).fetchWishList();
        },
      );
    }

    final wishlist = state.wishlist;

    if (wishlist == null || wishlist.items.isEmpty) {
      return EmptyWishlistScreen(onContinueShopping: (){
        ref.read(bottomNavProvider.notifier).changeIndex(0);
      },);
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(wishNotifierProvider.notifier).refresh();
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: wishlist.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = wishlist.items[index];
      
            return WishlistItemCard(item: item, onRemove: () {
              ref.read(wishNotifierProvider.notifier).removeFromWishList(item.id);
            }, onAddToCart: () {  },);
          },
        ),
      ),
    );
  }
}
