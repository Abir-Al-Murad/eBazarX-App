import 'package:ebazarx/features/banner/presentation/providers/banner_providers.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:ebazarx/features/flash_sale/presentation/providers/flash_sale_providers.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> loadNecessaryData(WidgetRef ref) async {
  Future<void> safe(Future<void> future) async {
    debugPrint("Getting Necessary Data");
    try {
      await future;
    } catch (_) {}
  }

  await Future.wait([
    // safe(ref.read(profileNotifierProvider.notifier).fetchProfile()),
    safe(ref.read(publicBannerListNotifierProvider.notifier).fetchBanners()),
    safe(ref.read(categoryListNotifierProvider.notifier).fetchCategories(refresh: true)),
    safe(ref.read(flashSaleListNotifierProvider.notifier).fetchFlashSales()),
    safe(ref.read(userProductListNotifierProvider.notifier).fetchProducts(refresh: true)),
    safe(ref.read(wishNotifierProvider.notifier).fetchWishList()),
    safe(ref.read(orderListNotifierProvider.notifier).loadOrders()),
    safe(ref.read(cartNotifierProvider.notifier).fetchCart()),
  ]);
}

// print("fetch profile");
// await ref.read(profileNotifierProvider.notifier).fetchProfile();
// print("fetch banners");
// await ref.read(publicBannerListNotifierProvider.notifier).fetchBanners();
// await ref.read(categoryListNotifierProvider.notifier).fetchCategories(refresh: true);
// await ref.read(flashSaleListNotifierProvider.notifier).fetchFlashSales();
// await ref.read(orderListNotifierProvider.notifier).loadOrders();
// await ref.read(cartNotifierProvider.notifier).fetchCart();
// await ref.read(userProductListNotifierProvider.notifier).fetchProducts(refresh: true);
// await ref.read(wishNotifierProvider.notifier).fetchWishList();
