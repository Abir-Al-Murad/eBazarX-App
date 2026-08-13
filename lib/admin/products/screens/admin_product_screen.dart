// admin/products/screens/admin_products_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/admin/products/providers/admin_product_providers.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/error_view.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() {
      ref.read(adminProductListNotifierProvider.notifier).fetchProducts();
      ref
          .read(adminProductActionNotifierProvider.notifier)
          .fetchPendingProducts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.read(adminProductListNotifierProvider.notifier).refresh();
    ref.read(adminProductActionNotifierProvider.notifier).fetchPendingProducts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listState = ref.watch(adminProductListNotifierProvider);
    final actionState = ref.watch(adminProductActionNotifierProvider);

    final allProducts = listState.products ?? <Product>[];
    final pendingProducts = actionState.pendingProduct ?? <Product>[];
    final approvedCount =
        allProducts.where((p) => p.approvalStatus == 'approved').length;
    final rejectedCount =
        allProducts.where((p) => p.approvalStatus == 'rejected').length;

    final query = _searchController.text.trim().toLowerCase();
    bool matchesQuery(Product p) =>
        query.isEmpty || p.name.toLowerCase().contains(query);

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
                      title: 'Product Management',
                      subtitle: 'Manage your products',
                    ),
                  ),
                  if (context.isDesktop)
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: _refreshAll,
                      tooltip: 'Refresh',
                    ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              _SearchField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: context.paddingSizeDefault),
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
                  tabAlignment:
                  context.isDesktop ? TabAlignment.fill : TabAlignment.start,
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
                  labelPadding:
                  EdgeInsets.symmetric(horizontal: context.paddingSizeDefault),
                  tabs: [
                    Tab(text: 'All (${allProducts.length})'),
                    Tab(text: 'Pending (${pendingProducts.length})'),
                    Tab(text: 'Approved ($approvedCount)'),
                    Tab(text: 'Rejected ($rejectedCount)'),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refreshAll(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ProductPanel(
                        products: allProducts.where(matchesQuery).toList(),
                        isLoading: listState.isLoading ?? false,
                        isLoadingMore: listState.isLoadingMore ?? false,
                        hasMore: listState.hasMore ?? true,
                        failure: listState.failure,
                        onRetry: _refreshAll,
                        loadMore: () => ref
                            .read(adminProductListNotifierProvider.notifier)
                            .loadMore(),
                      ),
                      _ProductPanel(
                        products: pendingProducts.where(matchesQuery).toList(),
                        isPending: true,
                        isLoading: actionState.isLoading ?? false,
                        isLoadingMore: actionState.isLoadingMore ?? false,
                        hasMore: actionState.hasMore ?? true,
                        failure: actionState.failure,
                        onRetry: () => ref
                            .read(adminProductActionNotifierProvider.notifier)
                            .fetchPendingProducts(),
                        loadMore: () => ref
                            .read(adminProductActionNotifierProvider.notifier)
                            .loadMorePendingProduct(),
                      ),
                      _ProductPanel(
                        products: allProducts
                            .where((p) => p.approvalStatus == 'approved')
                            .where(matchesQuery)
                            .toList(),
                        isLoading: listState.isLoading ?? false,
                        isLoadingMore: listState.isLoadingMore ?? false,
                        hasMore: listState.hasMore ?? true,
                        failure: listState.failure,
                        onRetry: _refreshAll,
                        loadMore: () => ref
                            .read(adminProductListNotifierProvider.notifier)
                            .loadMore(),
                      ),
                      _ProductPanel(
                        products: allProducts
                            .where((p) => p.approvalStatus == 'rejected')
                            .where(matchesQuery)
                            .toList(),
                        isLoading: listState.isLoading ?? false,
                        isLoadingMore: listState.isLoadingMore ?? false,
                        hasMore: listState.hasMore ?? true,
                        failure: listState.failure,
                        onRetry: _refreshAll,
                        loadMore: () => ref
                            .read(adminProductListNotifierProvider.notifier)
                            .loadMore(),
                      ),
                    ],
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
// Search field
// ================================
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: context.fontSizeDefault),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search products...',
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.paddingSizeSmall,
          ),
        ),
      ),
    );
  }
}

// ================================
// Panel: handles loading / error / empty / responsive layout
// ================================
class _ProductPanel extends ConsumerWidget {
  final List<Product> products;
  final bool isPending;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;
  final VoidCallback onRetry;
  final VoidCallback loadMore;

  const _ProductPanel({
    required this.products,
    this.isPending = false,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.failure,
    required this.onRetry,
    required this.loadMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading && products.isEmpty) {
      return _ProductShimmerList(
        isDesktop: context.isDesktop,
        isTablet: context.isTablet,
      );
    }

    if (failure != null && products.isEmpty) {
      return ErrorView(onRetry: onRetry, failure: failure!,);
    }

    if (products.isEmpty) {
      return EmptyState(title: isPending ? 'No pending products' : 'No products', message: "No products found.", icon: Icons.search_off_rounded,);
    }

    if (context.isDesktop) {
      return _DesktopProductTable(
        products: products,
        loadMore: loadMore,
        hasMore: hasMore,
        isLoadingMore: isLoadingMore,
      );
    } else if (context.isTablet) {
      return _ProductGrid(
        products: products,
        loadMore: loadMore,
        hasMore: hasMore,
        isLoadingMore: isLoadingMore,
        crossAxisCount: 2,
      );
    }
    return _ProductGrid(
      products: products,
      loadMore: loadMore,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      crossAxisCount: 1,
    );
  }
}

// ================================
// Shimmer skeleton (mirrors real widget dimensions)
// ================================
class _ProductShimmerList extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  const _ProductShimmerList({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.cardColor;
    final highlightColor = theme.dividerColor.withValues(alpha: 0.3);

    if (isDesktop) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
        itemCount: 8,
        separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(context.radiusDefault),
            ),
          ),
        ),
      );
    }

    final crossAxisCount = isTablet ? 2 : 1;
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount == 1 ? 3.2 : 0.85,
        crossAxisSpacing: context.paddingSizeDefault,
        mainAxisSpacing: context.paddingSizeDefault,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(context.radiusLarge),
          ),
        ),
      ),
    );
  }
}

// ================================
// Desktop Table — scroll-controller-driven pagination
// ================================
class _DesktopProductTable extends ConsumerStatefulWidget {
  final List<Product> products;
  final VoidCallback loadMore;
  final bool hasMore;
  final bool isLoadingMore;

  const _DesktopProductTable({
    required this.products,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
  });

  @override
  ConsumerState<_DesktopProductTable> createState() =>
      _DesktopProductTableState();
}

class _DesktopProductTableState extends ConsumerState<_DesktopProductTable> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(context.radiusLarge),
          border: Border.all(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 24,
                headingRowHeight: 46,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                ),
                headingTextStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                dividerThickness: 0.6,
                columns: const [
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Price'), numeric: true),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Sales'), numeric: true),
                  DataColumn(label: Text('')),
                ],
                rows: widget.products.map((product) {
                  return DataRow(
                    cells: [
                      DataCell(_ProductNameCell(product: product)),
                      DataCell(
                        Text(
                          '৳${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(
                        StatusChip(status: product.approvalStatus, showDot: false),
                      ),
                      DataCell(Text('${product.totalSales}')),
                      DataCell(_ProductActionsMenu(product: product)),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (widget.isLoadingMore)
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductNameCell extends StatelessWidget {
  final Product product;
  const _ProductNameCell({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radiusSmall),
          child: CachedNetworkImage(
            imageUrl: product.primaryImage?.url ?? '',
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 42,
              height: 42,
              color: theme.dividerColor.withValues(alpha: 0.2),
            ),
            errorWidget: (_, __, ___) => Container(
              width: 42,
              height: 42,
              color: theme.dividerColor.withValues(alpha: 0.2),
              child: const Icon(Icons.image_not_supported_outlined, size: 18),
            ),
          ),
        ),
        SizedBox(width: context.paddingSizeSmall),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ================================
// Grid / List — scroll-controller-driven pagination
// (mobile = 1 column, tablet = 2 columns)
// ================================
class _ProductGrid extends StatefulWidget {
  final List<Product> products;
  final VoidCallback loadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final int crossAxisCount;

  const _ProductGrid({
    required this.products,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.crossAxisCount,
  });

  @override
  State<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<_ProductGrid> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: widget.crossAxisCount == 1
              ? SliverList.separated(
            itemCount: widget.products.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) =>
                _ProductCard(product: widget.products[index]),
          )
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: 0.78,
              crossAxisSpacing: context.paddingSizeDefault,
              mainAxisSpacing: context.paddingSizeDefault,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                  _ProductCard(product: widget.products[index]),
              childCount: widget.products.length,
            ),
          ),
        ),
        if (widget.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding:
              EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ================================
// Product Card (used in grid + list)
// ================================
class _ProductCard extends ConsumerWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutesName.productDetails,
          pathParameters: {'product_id': product.id},
        ),
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeSmall),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.radiusDefault),
                child: CachedNetworkImage(
                  imageUrl: product.primaryImage?.url ?? '',
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: theme.cardColor,
                    highlightColor: theme.dividerColor.withValues(alpha: 0.3),
                    child: Container(width: 68, height: 68, color: theme.cardColor),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 68,
                    height: 68,
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              SizedBox(width: context.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.fontSizeDefault,
                            ),
                          ),
                        ),
                        _ProductActionsMenu(product: product, compact: true),
                      ],
                    ),
                    SizedBox(height: context.paddingSizeExtraSmall),
                    Text(
                      '৳${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: context.paddingSizeExtraSmall),
                    Row(
                      children: [
                        StatusChip(status: product.approvalStatus, showDot: false),
                        const Spacer(),
                        Text(
                          '${product.totalSales} sold',
                          style: TextStyle(
                            fontSize: context.fontSizeSmall,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
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
// Actions menu (3-dot popup) — View + change status to any status
// ================================
class _ProductActionsMenu extends ConsumerWidget {
  final Product product;
  final bool compact;

  const _ProductActionsMenu({required this.product, this.compact = false});

  static const _statusMeta = {
    'approved': (label: 'Mark Approved', icon: Icons.check_circle_outline),
    'pending': (label: 'Mark Pending', icon: Icons.hourglass_empty_rounded),
    'rejected': (label: 'Reject', icon: Icons.cancel_outlined),
  };

  Color _colorFor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = product.approvalStatus;
    final otherStatuses = _statusMeta.keys.where((s) => s != currentStatus);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: compact ? 20 : 22),
      padding: EdgeInsets.zero,
      tooltip: 'Actions',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      onSelected: (value) {
        if (value == 'view') {
          context.pushNamed(
            AppRoutesName.productDetails,
            pathParameters: {'product_id': product.id},
          );
        } else {
          _changeStatus(context, ref, product.id, value);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.visibility_outlined),
            title: Text('View'),
          ),
        ),
        const PopupMenuDivider(height: 8),
        for (final status in otherStatuses)
          PopupMenuItem(
            value: status,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_statusMeta[status]!.icon, color: _colorFor(status)),
              title: Text(_statusMeta[status]!.label),
            ),
          ),
      ],
    );
  }
}

// ================================
// Change status action (reason required only when rejecting)
// ================================
void _changeStatus(
    BuildContext context, WidgetRef ref, String productId, String targetStatus) async {
  String? reason;
  if (targetStatus == 'rejected') {
    reason = await showDialog<String>(
      context: context,
      builder: (_) => const _RejectionDialog(),
    );
    if (reason == null || reason.isEmpty) return;
  }

  final success = await ref
      .read(adminProductActionNotifierProvider.notifier)
      .updateApprovalStatus(productId, targetStatus, reason);

  if (success && context.mounted) {
    AppSnackBar.info(context: context, 'Product marked as $targetStatus');
    ref.read(adminProductActionNotifierProvider.notifier).fetchPendingProducts();
    ref.read(adminProductListNotifierProvider.notifier).refresh();
  }
}

// ================================
// Rejection Dialog
// ================================
class _RejectionDialog extends StatefulWidget {
  const _RejectionDialog();

  @override
  State<_RejectionDialog> createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<_RejectionDialog> {
  final _controller = TextEditingController();
  bool _isEmpty = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusLarge),
      ),
      title: const Text('Reject Product'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        onChanged: (v) => setState(() => _isEmpty = v.trim().isEmpty),
        decoration: InputDecoration(
          hintText: 'Reason for rejection',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.radiusDefault),
          ),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed:
          _isEmpty ? null : () => Navigator.pop(context, _controller.text.trim()),
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}