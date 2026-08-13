import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/app/assets_path.dart';
import 'package:ebazarx/common/utils/invalidate_providers.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ================= DESKTOP =================
    if (isDesktop) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width: 260,
                child: _AdminSidebar(
                  selectedIndex: widget.navigationShell.currentIndex,
                  onTap: _goToBranch,
                ),
              ),
              Expanded(
                child: Container(
                  color: isDark
                      ? theme.scaffoldBackgroundColor
                      : const Color(0xffF7F8FA),
                  child: widget.navigationShell,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ================= TABLET + MOBILE =================
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.5,
        title: Image.asset(
          AssetsPath.logoHorizontal,
          height: 40,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _AdminDrawer(
        selectedIndex: widget.navigationShell.currentIndex,
        onTap: _goToBranch,
      ),
      body: SafeArea(
        child: Container(
          color: isDark
              ? theme.scaffoldBackgroundColor
              : const Color(0xffF7F8FA),
          child: widget.navigationShell,
        ),
      ),
    );
  }
}

// ===========================================================
// NAVIGATION ITEMS CONFIGURATION
// ===========================================================

class _NavItem {
  final IconData icon;
  final String title;

  const _NavItem(this.icon, this.title);
}

const List<_NavItem> _adminNavItems = [
  _NavItem(Icons.dashboard_rounded, 'Dashboard'),
  _NavItem(Icons.inventory_2_rounded, 'Products'),
  _NavItem(Icons.shopping_cart_rounded, 'Orders'),
  _NavItem(Icons.image_rounded, 'Banners'),
  _NavItem(Icons.category_rounded, 'Categories'),
  _NavItem(Icons.local_offer_rounded, 'Coupons'),
  _NavItem(Icons.flash_on_outlined, 'Flash Sale'),
  _NavItem(Icons.store_rounded, 'Sellers'),
  _NavItem(Icons.reviews_rounded, 'Reviews'),
  _NavItem(Icons.people_alt_rounded, 'Users'),
  _NavItem(Icons.analytics_rounded, 'Analytics'),
];

// ===========================================================
// ADMIN SIDEBAR
// ===========================================================

class _AdminSidebar extends ConsumerWidget {
  const _AdminSidebar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            // color: theme.primaryColor,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  // backgroundColor: Colors.,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(AssetsPath.logoRaw),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'eBazar Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _adminNavItems.length,
              itemBuilder: (context, index) {
                final item = _adminNavItems[index];
                return _buildListTile(
                  context: context,
                  icon: item.icon,
                  title: item.title,
                  index: index,
                  isSelected: selectedIndex == index,
                  isDark: isDark,
                  onTap: () => onTap(index),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _handleLogout(context, ref),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isSelected ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade200 : Colors.black87),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

// ===========================================================
// ADMIN DRAWER (MOBILE / TABLET)
// ===========================================================

class _AdminDrawer extends ConsumerWidget {
  const _AdminDrawer({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(AssetsPath.logoRaw),
                ),
              ),
              accountName: const Text(
                'eBazar Admin Panel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text('admin@ebazarx.com'),
            ),

            // Navigation Options
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _adminNavItems.length,
                itemBuilder: (context, index) {
                  final item = _adminNavItems[index];
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    child: Material(
                      color: isSelected
                          ? theme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(
                          item.icon,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                ? Colors.grey.shade200
                                : Colors.black87),
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          onTap(index);
                          Navigator.of(context).pop(); // Close drawer
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // Logout Option
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Close drawer first
                _handleLogout(context, ref);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// Helper Logout Handler
Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
  invalidateUserProviders(ref.read);

  final refreshToken = await AuthStorage.instance.getRefreshToken();

  if (refreshToken != null) {
    await ref
        .read(authNotifierProvider.notifier)
        .logout(refreshToken: refreshToken);
  }

  if (context.mounted) {
    context.goNamed(AppRoutesName.login);
  }
}