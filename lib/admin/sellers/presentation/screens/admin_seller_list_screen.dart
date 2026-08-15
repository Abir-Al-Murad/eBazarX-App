// admin/sellers/presentation/screens/admin_seller_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/admin/sellers/presentation/providers/seller_providers.dart';
import 'package:ebazarx/admin/sellers/presentation/screens/admin_seller_detail_screen.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSellerListScreen extends ConsumerStatefulWidget {
  const AdminSellerListScreen({super.key});

  @override
  ConsumerState<AdminSellerListScreen> createState() =>
      _AdminSellerListScreenState();
}

class _AdminSellerListScreenState extends ConsumerState<AdminSellerListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _statuses = ['all', 'pending', 'approved', 'rejected'];
  static const _statusLabels = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchSellers();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSellers());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _selectedStatus => _statuses[_tabController.index];

  void _fetchSellers() {
    final notifier = ref.read(sellerListNotifierProvider.notifier);
    if (_selectedStatus == 'pending') {
      notifier.getPendingSellers();
    } else {
      notifier.getAllSellers(status: _selectedStatus == 'all' ? null : _selectedStatus);
    }
  }

  void _navigateToDetail(SellerEntity seller) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminSellerDetailScreen(seller: seller)),
    ).then((_) => _fetchSellers());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(sellerListNotifierProvider);

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
                      title: 'Sellers',
                      subtitle: 'Review and manage marketplace sellers',
                    ),
                  ),
                  if (context.isDesktop)
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: _fetchSellers,
                      tooltip: 'Refresh',
                    ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(context.radiusLarge),
                  border: Border.all(color: theme.dividerColor),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeSmall,
                  vertical: context.paddingSizeExtraSmall,
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: !context.isDesktop,
                  tabAlignment: context.isDesktop ? TabAlignment.fill : TabAlignment.start,
                  splashBorderRadius: BorderRadius.circular(context.radiusLarge),
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(context.radiusLarge),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontSize: context.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: context.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: context.paddingSizeDefault),
                  tabs: _statusLabels.map((label) => Tab(text: label)).toList(),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _fetchSellers(),
                  child: _SellerBody(
                    isLoading: state.isLoading,
                    sellers: state.sellers,
                    onTap: _navigateToDetail,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================
// Body: loading / empty / responsive content
// ================================
class _SellerBody extends StatelessWidget {
  const _SellerBody({required this.isLoading, required this.sellers, required this.onTap});

  final bool isLoading;
  final List<SellerEntity> sellers;
  final ValueChanged<SellerEntity> onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading && sellers.isEmpty) {
      return const LoadingContainer();
    }

    if (sellers.isEmpty) {
      return const EmptyState(
        icon: Icons.storefront_outlined,
        title: 'No sellers found',
        message: 'No sellers match this filter yet.',
      );
    }

    return context.isDesktop
        ? _DesktopSellerTable(sellers: sellers, onTap: onTap)
        : _SellerGrid(
      sellers: sellers,
      crossAxisCount: context.isTablet ? 2 : 1,
      onTap: onTap,
    );
  }
}

// ================================
// Desktop table
// ================================
class _DesktopSellerTable extends StatelessWidget {
  const _DesktopSellerTable({required this.sellers, required this.onTap});

  final List<SellerEntity> sellers;
  final ValueChanged<SellerEntity> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(context.radiusLarge),
          border: Border.all(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 46,
          dataRowMinHeight: 68,
          dataRowMaxHeight: 68,
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          headingTextStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          dividerThickness: 0.6,
          columns: const [
            DataColumn(label: Text('Shop')),
            DataColumn(label: Text('Contact')),
            DataColumn(label: Text('Location')),
            DataColumn(label: Text('Rating')),
            DataColumn(label: Text('Products')),
            DataColumn(label: Text('Orders')),
            DataColumn(label: Text('Commission')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('')),
          ],
          rows: sellers.map((seller) {
            return DataRow(
              onSelectChanged: (_) => onTap(seller),
              cells: [
                DataCell(_SellerNameCell(seller: seller)),
                DataCell(_SellerContactCell(seller: seller)),
                DataCell(_SellerLocationCell(seller: seller)),
                DataCell(_RatingPill(rating: seller.averageRating)),
                DataCell(Text('${seller.totalProducts}')),
                DataCell(Text('${seller.totalOrders}')),
                DataCell(Text('${seller.commissionRate.toStringAsFixed(1)}%')),
                DataCell(StatusChip(status: seller.status, showDot: false)),
                DataCell(Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SellerNameCell extends StatelessWidget {
  const _SellerNameCell({required this.seller});

  final SellerEntity seller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SellerAvatar(seller: seller, size: 40),
        SizedBox(width: context.paddingSizeSmall),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                seller.shopName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                seller.shopSlug,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SellerContactCell extends StatelessWidget {
  const _SellerContactCell({required this.seller});

  final SellerEntity seller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = seller.userEmail ?? seller.email;
    final phone = seller.userPhone ?? seller.phone;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (email != null)
            Text(email, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
          if (phone != null)
            Text(
              phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          if (email == null && phone == null)
            Text('—', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SellerLocationCell extends StatelessWidget {
  const _SellerLocationCell({required this.seller});

  final SellerEntity seller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = [seller.city, seller.district].whereType<String>().where((e) => e.isNotEmpty);
    final text = parts.isEmpty ? '—' : parts.join(', ');

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
    );
  }
}

// ================================
// Rating pill (shared)
// ================================
class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (rating <= 0) {
      return Text('—', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: context.fontSizeSmall, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ================================
// Grid / list (mobile 1 col, tablet 2 col)
// ================================
class _SellerGrid extends StatelessWidget {
  const _SellerGrid({
    required this.sellers,
    required this.crossAxisCount,
    required this.onTap,
  });

  final List<SellerEntity> sellers;
  final int crossAxisCount;
  final ValueChanged<SellerEntity> onTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: crossAxisCount == 1
              ? SliverList.separated(
            itemCount: sellers.length,
            separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => _SellerCard(
              seller: sellers[index],
              onTap: () => onTap(sellers[index]),
            ),
          )
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 2.0,
              crossAxisSpacing: context.paddingSizeDefault,
              mainAxisSpacing: context.paddingSizeDefault,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _SellerCard(
                seller: sellers[index],
                onTap: () => onTap(sellers[index]),
              ),
              childCount: sellers.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ================================
// Seller card (mobile / tablet)
// ================================
class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.seller, required this.onTap});

  final SellerEntity seller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = [seller.city, seller.district].whereType<String>().where((e) => e.isNotEmpty).join(', ');

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeSmall),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SellerAvatar(seller: seller, size: 48),
              SizedBox(width: context.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            seller.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.fontSizeDefault,
                            ),
                          ),
                        ),
                        StatusChip(status: seller.status, showDot: false),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      seller.shopSlug,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: context.paddingSizeExtraSmall),
                    Row(
                      children: [
                        _RatingPill(rating: seller.averageRating),
                        SizedBox(width: context.paddingSizeSmall),
                        Icon(Icons.inventory_2_outlined, size: 13, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text('${seller.totalProducts}', style: theme.textTheme.bodySmall),
                        SizedBox(width: context.paddingSizeSmall),
                        Icon(Icons.receipt_long_outlined, size: 13, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text('${seller.totalOrders}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                    if (location.isNotEmpty) ...[
                      SizedBox(height: context.paddingSizeExtraSmall),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================
// Avatar (shared by table + card)
// ================================
class _SellerAvatar extends StatelessWidget {
  const _SellerAvatar({required this.seller, required this.size});

  final SellerEntity seller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = seller.logo;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.radiusDefault),
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: size,
            height: size,
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
          errorWidget: (_, __, ___) => _SellerInitialAvatar(seller: seller, size: size),
        ),
      );
    }

    return _SellerInitialAvatar(seller: seller, size: size);
  }
}

class _SellerInitialAvatar extends StatelessWidget {
  const _SellerInitialAvatar({required this.seller, required this.size});

  final SellerEntity seller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      alignment: Alignment.center,
      child: Text(
        seller.shopName.isNotEmpty ? seller.shopName[0].toUpperCase() : '?',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}