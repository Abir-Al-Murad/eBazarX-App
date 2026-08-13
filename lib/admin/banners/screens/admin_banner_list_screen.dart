// admin/banners/screens/admin_banner_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/admin/banners/notifiers/admin_banner_list_notifier.dart';
import 'package:ebazarx/admin/banners/notifiers/admin_banner_notifier.dart';
import 'package:ebazarx/admin/banners/providers/admin_banner_provider.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_list_state.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/error_view.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminBannerListScreen extends ConsumerStatefulWidget {
  const AdminBannerListScreen({super.key});

  @override
  ConsumerState<AdminBannerListScreen> createState() =>
      _AdminBannerListScreenState();
}

class _AdminBannerListScreenState extends ConsumerState<AdminBannerListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminBannerListNotifierProvider.notifier).fetchBanners();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminBannerListNotifierProvider.notifier).loadMore();
    }
  }

  void _navigateToForm({BannerEntity? banner}) {
    context.pushNamed(AppRoutesName.adminBannerFrom, extra: banner);
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: 'Delete Banner',
        message: 'Are you sure you want to delete this banner? This action cannot be undone.',
        confirmLabel: 'Delete',
      ),
    );
    if (confirmed == true) {
      ref.read(adminBannerNotifierProvider.notifier).deleteBanner(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listState = ref.watch(adminBannerListNotifierProvider);
    final notifier = ref.read(adminBannerListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.paddingSizeLarge,
            context.paddingSizeLarge,
            context.paddingSizeLarge,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: DesktopHeader(
                      title: 'Banners',
                      subtitle: 'Manage homepage promotional banners',
                    ),
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => notifier.refresh(),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              Expanded(
                child: _BannerBody(state: listState, notifier: notifier),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Banner'),
      ),
    );
  }
}

// ================================
// Body: loading / error / empty / grid
// ================================
class _BannerBody extends ConsumerWidget {
  const _BannerBody({required this.state, required this.notifier});

  final AdminBannerListState state;
  final AdminBannerListNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.banners.isEmpty) {
      return const LoadingContainer();
    }

    if (state.failure != null && state.banners.isEmpty) {
      return ErrorView(
        failure: state.failure!,
        onRetry: () => notifier.fetchBanners(),
      );
    }

    if (state.banners.isEmpty) {
      return EmptyState(
        icon: Icons.image_outlined,
        title: 'No banners yet',
        message: 'Create a banner to promote deals and campaigns on the home screen.',
        buttonText: 'Add Banner',
        buttonIcon: Icons.add_rounded,
        onPressed: () => context.pushNamed(AppRoutesName.adminBannerFrom),
      );
    }

    final screen = context.findAncestorStateOfType<_AdminBannerListScreenState>();

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: GridView.builder(
        controller: screen?._scrollController,
        padding: EdgeInsets.only(bottom: context.paddingSizeExtraLarge),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive<int>(mobile: 1, tablet: 2, desktop: 3),
          childAspectRatio: context.isMobile ? 1.5 : 1.15,
          crossAxisSpacing: context.paddingSizeDefault,
          mainAxisSpacing: context.paddingSizeDefault,
        ),
        itemCount: state.banners.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.banners.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          final banner = state.banners[index];
          return _BannerCard(
            banner: banner,
            onEdit: () => screen?._navigateToForm(banner: banner),
            onDelete: () => screen?._confirmDelete(banner.id),
          );
        },
      ),
    );
  }
}

// ================================
// Banner Card
// ================================
class _BannerCard extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _BannerCard({required this.banner, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: banner.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Positioned(
                  top: context.paddingSizeSmall,
                  left: context.paddingSizeSmall,
                  child: StatusChip(
                    status: banner.isActive ? 'Active' : 'Inactive',
                  ),
                ),
                Positioned(
                  top: context.paddingSizeExtraSmall,
                  right: context.paddingSizeExtraSmall,
                  child: Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.edit_outlined,
                        onTap: onEdit,
                      ),
                      SizedBox(width: 6),
                      _RoundIconButton(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (banner.description.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.color, this.onTap});

  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: color ?? Colors.white),
        ),
      ),
    );
  }
}