import 'package:ebazarx/admin/banners/notifiers/admin_banner_list_notifier.dart';
import 'package:ebazarx/admin/banners/notifiers/admin_banner_notifier.dart';
import 'package:ebazarx/admin/banners/providers/admin_banner_provider.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_list_state.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminBannerListScreen extends ConsumerStatefulWidget {
  const AdminBannerListScreen({super.key});

  @override
  ConsumerState<AdminBannerListScreen> createState() =>
      _AdminBannerListScreenState();
}

class _AdminBannerListScreenState
    extends ConsumerState<AdminBannerListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminBannerListNotifierProvider.notifier).fetchBanners();
    });
    // Listen for scroll to load more
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminBannerListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(adminBannerListNotifierProvider);
    final notifier = ref.read(adminBannerListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refresh(),
          ),
        ],
      ),
      body: _buildBody(listState, notifier),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
      AdminBannerListState state,
      AdminBannerListNotifier notifier,
      ) {
    if (state.isLoading && state.banners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.failure != null && state.banners.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.failure!.message}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.fetchBanners(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: crossAxisCount == 1
                  ? double.infinity
                  : (crossAxisCount == 2 ? 400 : 300),
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.banners.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.banners.length && state.hasMore) {
                return const Center(child: CircularProgressIndicator());
              }
              final banner = state.banners[index];
              return _BannerCard(
                banner: banner,
                onEdit: () => _navigateToForm(context, banner: banner),
                onDelete: () => _confirmDelete(context, banner.id),
              );
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width < 600) return 1; // mobile
    if (width < 1200) return 2; // tablet
    return 3; // desktop
  }

  void _navigateToForm(BuildContext context, {BannerEntity? banner}) {
    context.pushNamed(AppRoutesName.adminBannerFrom, extra: banner);
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Banner'),
        content: const Text('Are you sure you want to delete this banner?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminBannerNotifierProvider.notifier).deleteBanner(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BannerCard({
    required this.banner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              banner.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (banner.description.isNotEmpty)
                  Text(
                    banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(banner.isActive ? 'Active' : 'Inactive'),
                      backgroundColor:
                      banner.isActive ? Colors.green[100] : Colors.grey[300],
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: banner.isActive ? Colors.green[800] : Colors.grey[700],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: onEdit,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}