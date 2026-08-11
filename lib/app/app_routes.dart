// lib/app/app_routes.dart
import 'package:ebazarx/admin/admin_shell.dart';
import 'package:ebazarx/admin/banners/screens/admin_banner_form_screen.dart';
import 'package:ebazarx/admin/banners/screens/admin_banner_list_screen.dart';
import 'package:ebazarx/admin/categories/screens/admin_category_form_screen.dart';
import 'package:ebazarx/admin/categories/screens/admin_category_list_screen.dart';
import 'package:ebazarx/admin/dashboard/screens/admin_dashboard_screen.dart';
import 'package:ebazarx/admin/orders/screens/admin_order_details_screen.dart';
import 'package:ebazarx/admin/orders/screens/admin_orders_screen.dart';
import 'package:ebazarx/admin/products/screens/admin_product_screen.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/screens/bottom_nav_holder.dart';
import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/presentation/screens/address_screen.dart';
import 'package:ebazarx/features/address/presentation/screens/add_address_screen.dart';
import 'package:ebazarx/features/auth/presentation/screens/login_screen.dart';
import 'package:ebazarx/features/auth/presentation/screens/registration_screen.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/presentation/screens/check_out_screen.dart';
import 'package:ebazarx/features/order/presentation/screens/order_details_screen.dart';
import 'package:ebazarx/features/order/presentation/screens/order_list_screen.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/presentation/screens/product_details_screen.dart';
import 'package:ebazarx/features/reviews/presentation/screens/review_screen.dart';
import 'package:ebazarx/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ebazarx/features/splash/presentation/screens/splash_screen.dart';
import 'package:ebazarx/seller/dashborad/screens/seller_dashboard_screen.dart';
import 'package:ebazarx/seller/orders/screens/seller_orders_screen.dart';
import 'package:ebazarx/seller/products/screens/add_product_screen.dart';
import 'package:ebazarx/seller/products/screens/seller_product_details_screen.dart';
import 'package:ebazarx/seller/products/screens/seller_product_screen.dart';
import 'package:ebazarx/seller/seller_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  // ─── Navigator Keys ──────────────────────────────────────────────
  // Root navigator for the entire app
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  // Seller shell branch navigators
  static final _sellerDashboardNavKey = GlobalKey<NavigatorState>();
  static final _sellerProductsNavKey  = GlobalKey<NavigatorState>();
  static final _sellerOrdersNavKey    = GlobalKey<NavigatorState>();

  // Admin shell branch navigators (only one now, but ready for more)
  static final _adminDashboardNavKey  = GlobalKey<NavigatorState>();
  static final _adminProductsNavKey  = GlobalKey<NavigatorState>();
  static final _adminOrderNavKey  = GlobalKey<NavigatorState>();
  static final _adminBannerNavKey  = GlobalKey<NavigatorState>();
  static final _adminCategoryNavKey  = GlobalKey<NavigatorState>();

  // Optional: you can also keep separate keys for other features if needed

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutesName.splash,
    routes: [
      // ─── Splash ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutesName.splash,
        name: AppRoutesName.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ─── Authentication ────────────────────────────────────────
      GoRoute(
        path: '/auth/login',
        name: AppRoutesName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutesName.register,
        name: AppRoutesName.register,
        builder: (context, state) => const RegistrationScreen(),
      ),

      // ─── Customer (BottomNav) ──────────────────────────────────
      GoRoute(
        path: AppRoutesName.widgetTree,
        name: AppRoutesName.widgetTree,
        builder: (context, state) => const BottomNavHolder(),
      ),


      GoRoute(
        path: '/customer/orders/:order_id',
        name: AppRoutesName.orderDetails,
        builder: (context, state) {
          final orderId = state.pathParameters['order_id']!;
          return OrderDetailsScreen(orderId: orderId);
        },
      ),


      // ─── Seller StatefulShellRoute ─────────────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        branches: [
          // Seller Dashboard
          StatefulShellBranch(
            navigatorKey: _sellerDashboardNavKey,
            routes: [
              GoRoute(
                path: '/seller/dashboard',
                name: AppRoutesName.sellerDashboard,
                builder: (context, state) => const SellerDashboardScreen(),
              ),
            ],
          ),
          // Seller Products
          StatefulShellBranch(
            navigatorKey: _sellerProductsNavKey,
            routes: [
              GoRoute(
                path: '/seller/products',
                name: AppRoutesName.products,
                builder: (context, state) => const SellerProductsScreen(),
                routes: [
                  // ✅ Nested routes use RELATIVE paths (no leading slash)
                  GoRoute(
                    path: 'add',
                    name: AppRoutesName.addEditProduct,
                    builder: (context, state) {
                      final product = state.extra as Product?;
                      return SellerAddProductScreen(existingProduct: product);
                    },
                  ),
                  GoRoute(
                    path: ':product_id',
                    name: AppRoutesName.sellerProductDetails,
                    builder: (context, state) {
                      final productId = state.pathParameters['product_id']!;
                      return SellerProductDetailsScreen(productId: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Seller Orders
          StatefulShellBranch(
            navigatorKey: _sellerOrdersNavKey,
            routes: [
              GoRoute(
                path: '/seller/orders',
                name: AppRoutesName.orders,
                builder: (context, state) => const SellerOrdersScreen(),
              ),
            ],
          ),

        ],
        builder: (context, state, navigationShell) {
          return SellerShell(navigationShell: navigationShell);
        },
      ),

      // ─── Admin StatefulShellRoute ──────────────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: _adminDashboardNavKey,
            routes: [
              GoRoute(
                path: '/admin/dashboard',
                name: AppRoutesName.adminDashboard,
                builder: (context, state) => const AdminDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
              navigatorKey: _adminProductsNavKey,
              routes: [
            GoRoute(
              path: '/admin/products',
              name: AppRoutesName.adminProducts,
              builder: (context, state) => const AdminProductsScreen(),
            ),
          ])    ,
          StatefulShellBranch(
              navigatorKey: _adminOrderNavKey,
              routes: [
            GoRoute(
              path: '/admin/orders',
              name: AppRoutesName.adminOrders,
              builder: (context, state) => const AdminOrdersScreen(),
            ),

                GoRoute(
              path: ':order_id',
              name: AppRoutesName.adminOrderDetailsScreen,
              builder: (context, state) => AdminOrderDetailsScreen(orderId: state.pathParameters['order_id']!),
            ),
          ]),

          // Seller Orders
          StatefulShellBranch(
            navigatorKey: _adminBannerNavKey,
            routes: [
              GoRoute(
                path: '/admin/banners',
                name: AppRoutesName.adminBanners,
                builder: (context, state) => const AdminBannerListScreen(),
              ),
              GoRoute(
                path: '/form',
                name: AppRoutesName.adminBannerFrom,
                builder: (context, state) =>  AdminBannerFormScreen(banner: state.extra as BannerEntity?),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminCategoryNavKey,
            routes: [
              GoRoute(
                path: '/admin/categories',
                name: AppRoutesName.adminCategories,
                builder: (context, state) => const AdminCategoryListScreen(),
              ),
              GoRoute(
                path: '/admin/categories/create',
                name: AppRoutesName.adminCategoryForm,
                builder: (context, state) =>  AdminCategoryFormScreen(category: state.extra as Category?),
              ),
            ],
          ),
          // Add more admin branches here later (e.g., /admin/users)
        ],
        builder: (context, state, navigationShell) {
          return AdminShell(navigationShell: navigationShell);
        },
      ),

      // ─── Public / Shared Routes ─────────────────────────────────
      GoRoute(
        path: '/product/:product_id',
        name: AppRoutesName.productDetails,
        builder: (context, state) =>
            ProductDetailsScreen(productId: state.pathParameters['product_id']!),
      ),
      GoRoute(
        path: '/customer/addresses/add',
        name: AppRoutesName.addAddress,
        builder: (context, state) {
          final address = state.extra as AddressEntity?;
          return AddAddressScreen(address: address);
        },
      ),
      GoRoute(
        path: '/checkout',
        name: AppRoutesName.checkout,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CheckoutScreen(
            items: extra['items'] as List<CheckoutItemEntity>,
            fromCart: extra['fromCart'] as bool,
            subtotal: extra['subTotal'] as double,
          );
        },
      ),
      GoRoute(
        path: '/customer/addresses',
        name: AppRoutesName.address,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: '/reviews/:productId',
        builder: (context, state) =>
            ReviewsScreen(productId: state.pathParameters['productId']!),
      ),

      // ─── (Optional) More routes like search, categories, etc. ──
      // Keep your commented routes here if needed – they are safe.
    ],
  );
}