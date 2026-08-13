import 'package:ebazarx/admin/dashboard/providers/admin_dashboard_providers.dart';
import 'package:ebazarx/admin/dashboard/widgets/recent_orders_card.dart';
import 'package:ebazarx/admin/dashboard/widgets/revenue_card.dart';
import 'package:ebazarx/admin/dashboard/widgets/top_products_card.dart';
import 'package:ebazarx/admin/dashboard/widgets/top_seller_card.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/error_view.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/section_tile.dart';
import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminDashboardNotifierProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminDashboardNotifierProvider);
    final dashboard = state.stats;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: state.isLoading
          ? const LoadingContainer()
          : state.failure != null
          ? ErrorView(
        failure: state.failure!,
        onRetry: () {
          ref
              .read(adminDashboardNotifierProvider.notifier)
              .loadDashboard();
        },
      )
          : RefreshIndicator(
        onRefresh: () => ref
            .read(adminDashboardNotifierProvider.notifier)
            .loadDashboard(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(context.paddingSizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DesktopHeader(
                title: 'Admin Dashboard',
                subtitle: 'Overview of your eBazarX marketplace',
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              _StatsGrid(
                totalOrders: dashboard?.totalOrders ?? 0,
                totalRevenue: dashboard?.totalRevenue ?? 0.0,
                totalProducts: dashboard?.totalProducts ?? 0,
                totalCustomers: dashboard?.totalCustomers ?? 0,
                totalSellers: dashboard?.totalSellers ?? 0,
                pendingOrders: dashboard?.pendingOrders ?? 0,
                completedOrders: dashboard?.completedOrders ?? 0,
                cancelledOrders: dashboard?.cancelledOrders ?? 0,
                pendingSellers: dashboard?.pendingSellers ?? 0,
                pendingProducts: dashboard?.pendingProducts ?? 0,
                todayOrders: dashboard?.todayOrders ?? 0,
                todayRevenue: dashboard?.todayRevenue ?? 0.0,
              ),
              SizedBox(height: context.paddingSizeExtraLarge + 4),
              const SectionTitle(
                title: 'Recent Orders',
                subtitle: 'Latest orders from customers',
              ),
              SizedBox(height: context.paddingSizeSmall),
              RecentOrdersCard(orders: state.recentOrders),
              SizedBox(height: context.paddingSizeExtraLarge + 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  final products = TopProductsCard(
                    products: state.topProducts,
                  );
                  final sellers = TopSellersCard(
                    sellers: state.topSellers,
                  );
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: products),
                        SizedBox(width: context.paddingSizeDefault),
                        Expanded(child: sellers),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      products,
                      SizedBox(height: context.paddingSizeDefault),
                      sellers,
                    ],
                  );
                },
              ),
              SizedBox(height: context.paddingSizeExtraLarge + 4),
              RevenueCard(revenue: state.revenue),
              SizedBox(height: context.paddingSizeExtraLarge),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// STATS GRID
// ============================================================

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalCustomers,
    required this.totalSellers,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.pendingSellers,
    required this.pendingProducts,
    required this.todayOrders,
    required this.todayRevenue,
  });

  final int totalOrders;
  final double totalRevenue;
  final int totalProducts;
  final int totalCustomers;
  final int totalSellers;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int pendingSellers;
  final int pendingProducts;
  final int todayOrders;
  final double todayRevenue;

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatCard(
        title: 'Total Revenue',
        value: '৳${totalRevenue.toStringAsFixed(2)}',
        icon: Icons.payments_rounded,
        color: AppColors.success,
      ),
      StatCard(
        title: "Today's Revenue",
        value: '৳${todayRevenue.toStringAsFixed(2)}',
        icon: Icons.trending_up_rounded,
        color: AppColors.success,
      ),
      StatCard(
        title: 'Total Orders',
        value: '$totalOrders',
        icon: Icons.shopping_cart_rounded,
        color: AppColors.pending,
      ),
      StatCard(
        title: "Today's Orders",
        value: '$todayOrders',
        icon: Icons.today_rounded,
        color: AppColors.draft,
      ),
      StatCard(
        title: 'Completed Orders',
        value: '$completedOrders',
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
      ),
      StatCard(
        title: 'Pending Orders',
        value: '$pendingOrders',
        icon: Icons.pending_actions_rounded,
        color: AppColors.warning,
      ),
      StatCard(
        title: 'Cancelled Orders',
        value: '$cancelledOrders',
        icon: Icons.cancel_rounded,
        color: AppColors.error,
      ),
      StatCard(
        title: 'Products',
        value: '$totalProducts',
        icon: Icons.inventory_2_rounded,
        color: AppColors.pending,
      ),
      StatCard(
        title: 'Pending Products',
        value: '$pendingProducts',
        icon: Icons.hourglass_bottom_rounded,
        color: AppColors.warning,
      ),
      StatCard(
        title: 'Customers',
        value: '$totalCustomers',
        icon: Icons.people_rounded,
        color: AppColors.archived,
      ),
      StatCard(
        title: 'Sellers',
        value: '$totalSellers',
        icon: Icons.store_rounded,
        color: AppColors.draft,
      ),
      StatCard(
        title: 'Pending Sellers',
        value: '$pendingSellers',
        icon: Icons.person_search_rounded,
        color: AppColors.outOfStock,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive<int>(
          mobile: 2,
          tablet: 3,
          desktop: 4,
        ),
        crossAxisSpacing: context.paddingSizeDefault,
        mainAxisSpacing: context.paddingSizeDefault,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) => cards[index],
    );
  }
}

