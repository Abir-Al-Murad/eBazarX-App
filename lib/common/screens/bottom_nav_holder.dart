import 'dart:ui';
// import 'package:ebazar/core/services/auth_storage.dart';
// import 'package:ebazar/features/banner/presentation/providers/banner_provider.dart';
// import 'package:ebazar/features/cart/presentation/screens/cart_screen.dart';
// import 'package:ebazar/features/categories/presentation/providers/category_provider.dart';
// import 'package:ebazar/features/home/presentation/screens/home_screen.dart';
// import 'package:ebazar/features/orders/presentation/providers/orders_provider.dart';
// import 'package:ebazar/features/orders/presentation/screens/order_list_screen.dart';
// import 'package:ebazar/features/product/presentation/providers/product_repository_provider.dart';
// import 'package:ebazar/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/banner/presentation/providers/banner_providers.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/cart/presentation/screens/cart_screen.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:ebazarx/features/flash_sale/presentation/providers/flash_sale_providers.dart';
import 'package:ebazarx/features/home/presentation/screens/home_screen.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/features/order/presentation/screens/order_list_screen.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/features/profile/presentation/screens/profile_screen.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:ebazarx/features/wish/presentation/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../features/cart/presentation/providers/cart_provider.dart';
// import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../providers/bottom_nav_provider.dart';

class BottomNavHolder extends ConsumerStatefulWidget {
  const BottomNavHolder({super.key});

  @override
  ConsumerState<BottomNavHolder> createState() => _BottomNavHolderState();
}

class _BottomNavHolderState extends ConsumerState<BottomNavHolder> {
  final _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const OrderListScreen(),
    const ProfileScreen(),
    // const OrderListScreen(),
    // const MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely call async code after the first frame
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkTokenAndLoadData();
    // });
    print("BottomNavHolder initState");
    Future.microtask(()async{
      print("fetch profile");
      await ref.read(profileNotifierProvider.notifier).fetchProfile();
      print("fetch banners");
      await ref.read(publicBannerListNotifierProvider.notifier).fetchBanners();
      await ref.read(categoryListNotifierProvider.notifier).fetchCategories(refresh: true);
      await ref.read(flashSaleListNotifierProvider.notifier).fetchFlashSales();
      await ref.read(orderListNotifierProvider.notifier).loadOrders();
      await ref.read(cartNotifierProvider.notifier).fetchCart();
      await ref.read(userProductListNotifierProvider.notifier).fetchProducts(refresh: true);
      await ref.read(wishNotifierProvider.notifier).fetchWishList();


    });
  }


  // // /// Load all data from various providers (only called when logged in)
  // void _loadAllData() {
  //   // ref.read(bannerNotifierProvider.notifier).loadActiveBanners();
  //   // ref.read(productListNotifierProvider.notifier).getProducts();
  //   // ref.read(categoryListProvider.notifier).loadCategories();
  //   // ref.read(cartNotifierProvider.notifier).loadCart();
  //   // ref.read(ordersListProvider.notifier).loadOrders();
  //   ref.read(profileNotifierProvider.notifier).fetchProfile();
  // }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(bottomNavProvider.notifier);
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _GlassNavBar(
        currentIndex: currentIndex,
        onTap: (value)  {
          // if (currentIndex == value) {
          //   // Same tab clicked -> refresh
          //   switch (value) {
          //     case 0:
          //        ref.read(bannerNotifierProvider.notifier).loadActiveBanners();
          //        ref.read(categoryListProvider.notifier).loadCategories();
          //        ref.read(productListNotifierProvider.notifier).getProducts(refresh: true);
          //       break;
          //
          //     case 1:
          //        ref.read(cartNotifierProvider.notifier).loadCart();
          //       break;
          //
          //     case 2:
          //        ref.read(ordersListProvider.notifier).loadOrders();
          //       break;
          //
          //     case 3:
          //        ref.read(profileNotifierProvider.notifier).refresh();
          //       break;
          //   }
          // } else {
          //   switch (value) {
          //     case 1:
          //        ref.read(cartNotifierProvider.notifier).loadCart();
          //       break;
          //
          //     case 2:
          //        ref.read(ordersListProvider.notifier).loadOrders();
          //       break;
          //   }
          //
            ref.read(bottomNavProvider.notifier).changeIndex(value);
          // }
        },
        items: const [
          _NavItem(icon: Icons.home_rounded, label: 'Home'),
          _NavItem(icon: Icons.favorite_outlined, label: 'Wishlist'),
          _NavItem(icon: Icons.shopping_cart_rounded, label: 'Cart'),
          _NavItem(icon: Icons.list_alt_rounded, label: 'Orders'),
          _NavItem(icon: Icons.person, label: 'Profile'),
          // _NavItem(icon: Icons.shopping_cart_rounded, label: 'Cart'),
          // _NavItem(icon: Icons.list_alt_rounded, label: 'Orders'),
          // _NavItem(icon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// A quieter, glass-styled nav bar: no filled pill, no sliding block —
/// just icons on a frosted translucent strip, with a single small dot
/// that appears under whichever tab is active. Meant to feel closer to
/// an iOS-style minimal tab bar than a "designed" widget.
class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final barColor = Theme.of(context).cardColor;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: barColor.withOpacity(0.72),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: List.generate(items.length, (index) {
                final selected = index == currentIndex;
                final item = items[index];

                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          scale: selected ? 1.0 : 0.9,
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: selected ? colors.primary : AppColors.textSecondary.withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? colors.primary : AppColors.textSecondary.withOpacity(0.55),
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}