import 'package:ebazarx/features/address/presentation/providers/address_providers.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/features/banner/presentation/providers/banner_providers.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/features/reviews/presentation/providers/review_providers.dart';
import 'package:ebazarx/features/wish/presentation/providers/wish_providers.dart';
import 'package:ebazarx/common/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Matches the signature of BOTH `Ref.read` and `WidgetRef.read`,
/// so this can be called from a Provider (ApiClient) or a Widget.
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

void invalidateUserProviders(ProviderReader read) {
  debugPrint('Resetting user providers');
  // read(bottomNavProvider.notifier).changeIndex(0);
  read(profileNotifierProvider.notifier).clearProfile();
  read(wishNotifierProvider.notifier).clearWishList();
  read(authNotifierProvider.notifier).clearAuth();
  read(cartNotifierProvider.notifier).reset();
  read(orderListNotifierProvider.notifier).reset();
  read(customerReviewNotifierProvider.notifier).clearCustomerState();
  read(productDetailsNotifierProvider.notifier).clearProductDetails();
  read(publicBannerListNotifierProvider.notifier).clearBannerList();
  read(categoryListNotifierProvider.notifier).reset();
  read(addressListProvider.notifier).reset();
}