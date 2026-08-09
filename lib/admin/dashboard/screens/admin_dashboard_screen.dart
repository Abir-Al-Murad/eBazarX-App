import 'package:ebazarx/admin/dashboard/providers/admin_dashboard_providers.dart';
import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';
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
      body: state.isLoading
          ? const _LoadingView()
          : state.failure != null
          ? _ErrorView(
              message: state.failure!.message,
              onRetry: () {
                ref
                    .read(adminDashboardNotifierProvider.notifier)
                    .loadDashboard();
              },
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(adminDashboardNotifierProvider.notifier)
                    .loadDashboard();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardHeader(),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 28),
                    const _SectionTitle(
                      title: 'Recent Orders',
                      subtitle: 'Latest orders from customers',
                    ),
                    const SizedBox(height: 12),
                    _RecentOrdersCard(orders: state.recentOrders),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 900) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _TopProductsCard(
                                  products: state.topProducts,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _TopSellersCard(
                                  sellers: state.topSellers,
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _TopProductsCard(products: state.topProducts),
                            const SizedBox(height: 20),
                            _TopSellersCard(sellers: state.topSellers),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    _RevenueCard(revenue: state.revenue),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'Overview of your eBazarX marketplace',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(radius: 20, child: Icon(Icons.admin_panel_settings)),
      ],
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
        icon: Icons.payments,
        color: Colors.green,
      ),
      StatCard(
        title: 'Total Orders',
        value: '$totalOrders',
        icon: Icons.shopping_cart,
        color: Colors.blue,
      ),
      StatCard(
        title: 'Products',
        value: '$totalProducts',
        icon: Icons.inventory_2,
        color: Colors.orange,
      ),
      StatCard(
        title: 'Customers',
        value: '$totalCustomers',
        icon: Icons.people,
        color: Colors.purple,
      ),
      StatCard(
        title: 'Sellers',
        value: '$totalSellers',
        icon: Icons.store,
        color: Colors.teal,
      ),
      StatCard(
        title: 'Pending Orders',
        value: '$pendingOrders',
        icon: Icons.pending_actions,
        color: Colors.amber,
      ),
      StatCard(
        title: 'Pending Products',
        value: '$pendingProducts',
        icon: Icons.pending,
        color: Colors.red,
      ),
      StatCard(
        title: 'Pending Sellers',
        value: '$pendingSellers',
        icon: Icons.person_search,
        color: Colors.deepOrange,
      ),
      StatCard(
        title: 'Completed Orders',
        value: '$completedOrders',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      StatCard(
        title: 'Cancelled Orders',
        value: '$cancelledOrders',
        icon: Icons.cancel,
        color: Colors.red,
      ),
      StatCard(
        title: "Today's Orders",
        value: '$todayOrders',
        icon: Icons.today,
        color: Colors.cyan,
      ),
      StatCard(
        title: "Today's Revenue",
        value: '৳${todayRevenue.toStringAsFixed(2)}',
        icon: Icons.trending_up,
        color: Colors.green,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isDesktop
            ? 4
            : context.isTablet
            ? 3
            : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// ============================================================
// RECENT ORDERS
// ============================================================

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard({required this.orders});

  final List<AdminRecentOrder> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyCard(message: 'No recent orders');
    }

    return Card(
      elevation: 0,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final order = orders[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 6,
            ),
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(
              '#${order.id.substring(0, 8).toUpperCase()}', // Use order ID
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(order.customerName ?? 'Guest Customer'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳${order.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _StatusChip(status: order.orderStatus),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// TOP PRODUCTS
// ============================================================

class _TopProductsCard extends StatelessWidget {
  const _TopProductsCard({required this.products});

  final List<AdminTopProduct> products;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            if (products.isEmpty)
              const _EmptyCard(message: 'No product data')
            else
              ...products.map(
                (product) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                  title: Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('${product.totalSales} sales'),
                  trailing: Text(
                    '৳${product.revenue.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TOP SELLERS
// ============================================================

class _TopSellersCard extends StatelessWidget {
  const _TopSellersCard({required this.sellers});

  final List<AdminTopSeller> sellers;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Sellers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            if (sellers.isEmpty)
              const _EmptyCard(message: 'No seller data')
            else
              ...sellers.map(
                (seller) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.store)),
                  title: Text(
                    seller.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('${seller.totalOrders} orders'),
                  trailing: Text(
                    '৳${seller.totalRevenue.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REVENUE
// ============================================================

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.revenue});

  final List<AdminRevenue> revenue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Revenue and orders for the selected period',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (revenue.isEmpty)
              const SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    'No revenue data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: revenue.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = revenue[index];
                    return Container(
                      width: 120,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue.withOpacity(.06),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.period,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '৳${item.revenue.toStringAsFixed(0)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${item.orders} orders',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STATUS CHIP
// ============================================================

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color? textColor;
    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange;
        break;
      case 'processing':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue;
        break;
      case 'shipped':
        bgColor = Colors.purple.shade50;
        textColor = Colors.purple;
        break;
      case 'delivered':
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case 'cancelled':
        bgColor = Colors.red.shade50;
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.shade50;
        textColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY
// ============================================================

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// ============================================================
// LOADING
// ============================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ============================================================
// ERROR
// ============================================================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
