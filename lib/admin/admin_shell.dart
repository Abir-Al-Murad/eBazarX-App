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

    // ================= DESKTOP =================
    if (isDesktop) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              _AdminSidebar(
                selectedIndex: widget.navigationShell.currentIndex,
                onTap: _goToBranch,
              ),

              Expanded(
                child: Container(
                  color: const Color(0xffF7F8FA),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Image.asset(AssetsPath.logoHorizontal, height: 70,width: 150,),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon:  Icon(Icons.menu,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.notifications_none,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,),
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
          color: const Color(0xffF7F8FA),
          child: widget.navigationShell,
        ),
      ),
    );
  }
}



// ===========================================================
// ADMIN SIDEBAR
// ===========================================================

class _AdminSidebar extends ConsumerWidget {
  const _AdminSidebar({required this.selectedIndex, required this.onTap});

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

          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.admin_panel_settings, size: 30),
          ),

          const SizedBox(height: 12),

          const Text(
            'eBazarX Admin',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 35),

          Expanded(
            child: ListView(
              children: [
                _item(Icons.dashboard_rounded, 'Dashboard', 0),

                _item(Icons.inventory_2_rounded, 'Products', 1),

                _item(Icons.shopping_cart_rounded, 'Orders', 2),

                _item(Icons.image_rounded, 'Banners', 3),
                _item(Icons.category_rounded, 'Categories', 4),

                _item(Icons.local_offer_rounded, 'Coupons', 5),
                _item(Icons.flash_on_outlined, 'Flash Sale', 6),
                _item(Icons.store_rounded, 'Sellers', 7),
                _item(Icons.reviews_rounded, 'Reviews', 8),

                _item(Icons.people_alt_rounded, 'Users', 9),




                _item(Icons.analytics_rounded, 'Analytics', 10),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
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
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: selected ? const Color(0xff2563EB) : Colors.transparent,
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

// ===========================================================
// ADMIN DRAWER
// ===========================================================

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({
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
              child: Image(image: AssetImage(AssetsPath.logoRaw))
            ),

            const SizedBox(height: 20),

            const Text(
              'eBazar Admin',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                children: [
                  _drawerItem(
                    context,
                    Icons.dashboard_rounded,
                    'Dashboard',
                    0,
                  ),
                  _drawerItem(
                    context,
                    Icons.inventory_2_rounded,
                    'Products',
                    1,
                  ),
                  _drawerItem(
                    context,
                    Icons.shopping_cart_rounded,
                    'Orders',
                    2,
                  ),
                  _drawerItem(
                    context,
                    Icons.image_rounded,
                    'Banners',
                    3,
                  ),
                  _drawerItem(
                    context,
                    Icons.people_alt_rounded,
                    'Users',
                    4,
                  ),
                  _drawerItem(
                    context,
                    Icons.store_rounded,
                    'Sellers',
                    5,
                  ),
                  _drawerItem(
                    context,
                    Icons.category_rounded,
                    'Categories',
                    6,
                  ),
                  _drawerItem(
                    context,
                    Icons.reviews_rounded,
                    'Reviews',
                    7,
                  ),
                  _drawerItem(
                    context,
                    Icons.local_offer_rounded,
                    'Coupons',
                    8,
                  ),

                  _drawerItem(
                    context,
                    Icons.analytics_rounded,
                    'Analytics',
                    9,
                  ),
                ],
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () => _logout(context),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context,
      IconData icon,
      String title,
      int index,
      ) {
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: Material(
        color: selected
            ? const Color(0xff2563EB)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            icon,
            color: selected
                ? Colors.white
                : Colors.grey.shade700,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.grey.shade800,
              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
          onTap: () {
            onTap(index);

            // Close drawer
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // You need WidgetRef here if using authNotifierProvider.
    // See note below.
  }
}
