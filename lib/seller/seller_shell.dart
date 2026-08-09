import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/app/assets_path.dart';
import 'package:ebazarx/common/utils/invalidate_providers.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SellerShell extends ConsumerStatefulWidget {
  const SellerShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<SellerShell> createState() => _SellerShellState();
}

class _SellerShellState extends ConsumerState<SellerShell> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryListNotifierProvider.notifier).fetchCategories();
    });
  }

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;

    // For desktop: use a sidebar + content layout
    if (isDesktop) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              _SellerSidebar(
                selectedIndex: widget.navigationShell.currentIndex,
                onTap: _goToBranch,
              ),
              Expanded(
                child: Column(
                  children: [
                    // Optional top bar (uncomment if needed)
                    // _TopBar(isDesktop: true),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF7F8FA),
                        child: widget.navigationShell,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // For tablet and mobile: use a Scaffold with AppBar and Drawer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              invalidateUserProviders(ref.read);
              final refreshToken =
              await AuthStorage.instance.getRefreshToken();
              await ref
                  .read(authNotifierProvider.notifier)
                  .logout(refreshToken: refreshToken!);
              context.goNamed(AppRoutesName.login);
            },
          ),
        ],
      ),
      drawer: _SellerDrawer(
        selectedIndex: widget.navigationShell.currentIndex,
        onTap: _goToBranch,
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF7F8FA),
          child: widget.navigationShell,
        ),
      ),
      // Optional: BottomNavigationBar for mobile
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goToBranch,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )
          : null,
    );
  }
}

// -------------------- Sidebar (Desktop) --------------------
class _SellerSidebar extends ConsumerWidget {
  const _SellerSidebar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 25),
           CircleAvatar(
            radius: 30,
            child: Image.asset(AssetsPath.logoRaw),
          ),
          const SizedBox(height: 12),
          const Text(
            "eBazar Seller",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 35),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(Icons.dashboard, "Dashboard", 0),
                _buildSidebarItem(Icons.inventory_2, "Products", 1),
                _buildSidebarItem(Icons.shopping_cart, "Orders", 2),
                _buildSidebarItem(Icons.analytics, "Analytics", 3),
                _buildSidebarItem(Icons.person, "Profile", 4),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              invalidateUserProviders(ref.read);
              final refreshToken =
              await AuthStorage.instance.getRefreshToken();
              await ref
                  .read(authNotifierProvider.notifier)
                  .logout(refreshToken: refreshToken!);
              context.goNamed(AppRoutesName.login);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    final selected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: selected ? const Color(0xFF2563EB) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            icon,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          onTap: () => onTap(index),
        ),
      ),
    );
  }
}

// -------------------- Drawer (Tablet / Mobile) --------------------
class _SellerDrawer extends StatelessWidget {
  const _SellerDrawer({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 35,
              child: Image(image: AssetImage(AssetsPath.logoRaw)),
            ),
            const SizedBox(height: 20),
            const Text(
              "eBazar Seller",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.dashboard, "Dashboard", 0),
                  _buildDrawerItem(Icons.inventory_2, "Products", 1),
                  _buildDrawerItem(Icons.shopping_cart, "Orders", 2),
                  _buildDrawerItem(Icons.analytics, "Analytics", 3),
                  _buildDrawerItem(Icons.person, "Profile", 4),
                  const Divider(),
                  _buildDrawerItem(Icons.logout, "Logout", -1,
                      isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon,
      String title,
      int index, {
        bool isLogout = false,
      }) {
    final selected = selectedIndex == index && !isLogout;
    return Consumer(
      builder: (context, ref, _) {
        return ListTile(
          leading: Icon(
            icon,
            color: isLogout ? Colors.red : (selected ? const Color(0xFF2563EB) : null),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLogout ? Colors.red : null,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            if (isLogout) {
              _logout(context, ref);
            } else {
              onTap(index);
              Navigator.of(context).pop(); // close drawer
            }
          },
        );
      },
    );
  }

  void _logout(BuildContext context, WidgetRef ref) async {
    invalidateUserProviders(ref.read);
    final refreshToken = await AuthStorage.instance.getRefreshToken();
    await ref
        .read(authNotifierProvider.notifier)
        .logout(refreshToken: refreshToken!);
    context.goNamed(AppRoutesName.login);
  }
}