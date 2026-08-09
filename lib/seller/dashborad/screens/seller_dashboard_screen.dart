import 'dart:ui';
import 'package:ebazarx/common/widgets/section_tile.dart';
import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';
import 'package:ebazarx/seller/dashborad/providers/seller_dashboard_providers.dart';
import 'package:ebazarx/seller/dashborad/screens/seller_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================================
// Main Screen
// ============================================================================

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState
    extends ConsumerState<SellerDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(sellerDashboardNotifierProvider.notifier)
          .loadSellerDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerDashboardNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dashboard = state.dashboardEntity;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dashboard == null) {
      return const Center(
        child: Text('Failed to load dashboard'),
      );
    }

    return Container(
      color: isDark
          ? Colors.grey[900]
          : const Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildDashboardContent(
          context,
          dashboard,
          isDark,
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context,
      DashboardEntity dashboard,
      bool isDark,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardHeader(),

        const SizedBox(height: 24),

        GridView.count(
          crossAxisCount: context.isDesktop?4:context.isTablet?3:2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: [
            StatCard(
              title: 'Total Orders',
              value: '${dashboard.totalOrders}',
              icon: Icons.shopping_bag_outlined,
              color: const Color(0xFF2563EB),
            ),

            StatCard(
              title: 'Completed',
              value: '${dashboard.completedOrders}',
              icon: Icons.check_circle_outline,
              color: const Color(0xFF22C55E),
            ),

            StatCard(
              title: 'Pending',
              value: '${dashboard.pendingOrders}',
              icon: Icons.hourglass_top_rounded,
              color: const Color(0xFFF59E0B),
            ),

            StatCard(
              title: 'Cancelled',
              value: '${dashboard.cancelledOrders}',
              icon: Icons.cancel_outlined,
              color: const Color(0xFFEF4444),
            ),

            StatCard(
              title: 'Revenue',
              value: '\$${dashboard.totalRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money_rounded,
              color: const Color(0xFF2563EB),
            ),

            StatCard(
              title: 'Available Balance',
              value: '\$${dashboard.availableBalance.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFF22C55E),
            ),

            StatCard(
              title: 'Pending Balance',
              value: '\$${dashboard.pendingBalance.toStringAsFixed(2)}',
              icon: Icons.hourglass_bottom_rounded,
              color: const Color(0xFFF59E0B),
            ),

            StatCard(
              title: 'Products',
              value: '${dashboard.totalProducts}',
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFF8B5CF6),
            ),

            StatCard(
              title: 'Average Rating',
              value: dashboard.averageRating.toStringAsFixed(1),
              icon: Icons.star_rounded,
              color: const Color(0xFFF59E0B),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const RevenueCard(),

        const SizedBox(height: 24),

        const SectionTitle(
          title: 'Recent Orders',
        ),

        const SizedBox(height: 12),

        const RecentOrdersTable(),

        const SizedBox(height: 24),

        const SectionTitle(
          title: 'Top Selling Products',
        ),

        const SizedBox(height: 12),

        const TopProductsCard(),

        const SizedBox(height: 24),

        const SectionTitle(
          title: 'Quick Actions',
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            QuickActionCard(
              icon: Icons.add_shopping_cart_rounded,
              label: 'Add Product',
              color: Color(0xFF2563EB),
            ),

            QuickActionCard(
              icon: Icons.local_offer_rounded,
              label: 'Create Discount',
              color: Color(0xFFF59E0B),
            ),

            QuickActionCard(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Withdraw Balance',
              color: Color(0xFF22C55E),
            ),

            QuickActionCard(
              icon: Icons.shopping_bag_rounded,
              label: 'Manage Orders',
              color: Color(0xFF8B5CF6),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// Reusable Widgets
// ============================================================================

// -------------------- Dashboard Header --------------------
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning, Abir',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back to your store.',
          style: textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// -------------------- Revenue Card --------------------
class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildPeriodButton(context, '7D', true),
                  const SizedBox(width: 8),
                  _buildPeriodButton(context, '30D', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Placeholder chart
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sales trend chart will appear here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(BuildContext context, String label, bool selected) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? theme.colorScheme.primary : const Color(0xFFE5E7EB),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: selected ? Colors.white : theme.colorScheme.onSurfaceVariant,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// -------------------- Recent Orders Table --------------------
class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dummy data
    final orders = [
      {'customer': 'John Doe', 'id': '#1234', 'amount': '\$120.00', 'payment': 'Paid', 'status': 'Delivered', 'date': '2025-03-01'},
      {'customer': 'Jane Smith', 'id': '#1235', 'amount': '\$85.50', 'payment': 'Pending', 'status': 'Processing', 'date': '2025-03-02'},
      {'customer': 'Robert Brown', 'id': '#1236', 'amount': '\$200.00', 'payment': 'Paid', 'status': 'Shipped', 'date': '2025-03-03'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateProperty.resolveWith(
                (states) => isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
          ),
          columns: const [
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Order ID')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Payment Status')),
            DataColumn(label: Text('Order Status')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Action')),
          ],
          rows: orders.map((order) {
            final paymentColor = order['payment'] == 'Paid' ? Colors.green : Colors.orange;
            final statusColor = order['status'] == 'Delivered' ? Colors.green : Colors.blue;

            return DataRow(
              cells: [
                DataCell(Text(order['customer']!)),
                DataCell(Text(order['id']!)),
                DataCell(Text(order['amount']!)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: paymentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order['payment']!,
                      style: TextStyle(
                        color: paymentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order['status']!,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(order['date']!)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// -------------------- Top Products Card --------------------
class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dummy data
    final products = [
      {'name': 'Wireless Headphones', 'sold': 120, 'revenue': '\$2,400'},
      {'name': 'Smartphone Case', 'sold': 95, 'revenue': '\$1,425'},
      {'name': 'USB-C Cable', 'sold': 80, 'revenue': '\$560'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < products.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sold: ${products[i]['sold']} • Revenue: ${products[i]['revenue']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// -------------------- Quick Action Card --------------------
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

