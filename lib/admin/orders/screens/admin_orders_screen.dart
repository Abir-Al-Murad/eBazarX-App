// admin/orders/screens/admin_orders_screen.dart
import 'package:ebazarx/admin/common/widgets/admin_search_field.dart';
import 'package:ebazarx/admin/orders/providers/admin_order_providers.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/error_view.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final List<OrderStatus> _statuses = OrderStatus.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length + 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(adminOrdersListProvider.notifier).getAllOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await ref.read(adminOrdersListProvider.notifier).getAllOrders();
  }

  Future<void> _changeOrderStatus(OrderEntity order, OrderStatus status) async {
    if (order.orderStatus.value == status.value) return;

    try {
      await ref
          .read(adminOrderProvider.notifier)
          .updateOrderStatus(order.id, status.value);
      await ref.read(adminOrdersListProvider.notifier).getAllOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status changed to ${status.displayName}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }
  }

  // ✅ New: Change payment status
  Future<void> _changePaymentStatus(OrderEntity order, PaymentStatus status) async {
    if (order.paymentStatus == status) return;

    try {
      await ref
          .read(updatePaymentStatusUseCaseProvider)
          .call(
        orderId: order.id,
        paymentStatus: status.name,
      );
      await ref.read(adminOrdersListProvider.notifier).getAllOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment status changed to ${status.name}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update payment status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(adminOrdersListProvider);
    final orders = state.items;

    final query = _searchController.text.trim().toLowerCase();
    bool matchesQuery(OrderEntity order) =>
        query.isEmpty ||
            order.id.toLowerCase().contains(query) ||
            order.userId.toLowerCase().contains(query);

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
                      title: 'Order Management',
                      subtitle: 'Track and manage customer orders',
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
              AdminSearchField(
                controller: _searchController,
                hintText: 'Search by order ID or customer...',
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
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
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
                    Tab(text: 'All (${orders.length})'),
                    ..._statuses.map((status) {
                      final count = orders
                          .where((o) => o.orderStatus.value == status.value)
                          .length;
                      return Tab(text: '${status.displayName} ($count)');
                    }),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshAll,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _OrderPanel(
                        orders: orders.where(matchesQuery).toList(),
                        isLoading: state.isLoading,
                        isLoadingMore: state.isLoadingMore,
                        hasMore: state.hasMore,
                        failure: state.failure,
                        onRetry: _refreshAll,
                        loadMore: () =>
                            ref.read(adminOrdersListProvider.notifier).loadMoreOrders(),
                        onChangeStatus: _changeOrderStatus,
                        onChangePaymentStatus: _changePaymentStatus,
                      ),
                      ..._statuses.map((status) {
                        return _OrderPanel(
                          orders: orders
                              .where((o) => o.orderStatus.value == status.value)
                              .where(matchesQuery)
                              .toList(),
                          isLoading: state.isLoading,
                          isLoadingMore: state.isLoadingMore,
                          hasMore: state.hasMore,
                          failure: state.failure,
                          onRetry: _refreshAll,
                          loadMore: () => ref
                              .read(adminOrdersListProvider.notifier)
                              .loadMoreOrders(),
                          onChangeStatus: _changeOrderStatus,
                          onChangePaymentStatus: _changePaymentStatus,
                        );
                      }),
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

// ============================================================
// ORDER PANEL
// ============================================================

class _OrderPanel extends StatefulWidget {
  final List<OrderEntity> orders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;
  final VoidCallback onRetry;
  final VoidCallback loadMore;
  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;
  final Future<void> Function(OrderEntity, PaymentStatus) onChangePaymentStatus;

  const _OrderPanel({
    required this.orders,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.failure,
    required this.onRetry,
    required this.loadMore,
    required this.onChangeStatus,
    required this.onChangePaymentStatus,
  });

  @override
  State<_OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<_OrderPanel> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.isLoading && widget.orders.isEmpty) {
      return _OrderSkeleton(isDesktop: context.isDesktop, isTablet: context.isTablet);
    }

    if (widget.failure != null && widget.orders.isEmpty) {
      return ErrorView(onRetry: widget.onRetry, failure: widget.failure!);
    }

    if (widget.orders.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders found',
        message: 'Try adjusting your search or filters',
      );
    }

    if (context.isDesktop) {
      return _DesktopOrderTable(
        orders: widget.orders,
        loadMore: widget.loadMore,
        hasMore: widget.hasMore,
        isLoadingMore: widget.isLoadingMore,
        onChangeStatus: widget.onChangeStatus,
        onChangePaymentStatus: widget.onChangePaymentStatus,
      );
    } else if (context.isTablet) {
      return _OrderGrid(
        orders: widget.orders,
        loadMore: widget.loadMore,
        hasMore: widget.hasMore,
        isLoadingMore: widget.isLoadingMore,
        crossAxisCount: 2,
        onChangeStatus: widget.onChangeStatus,
        onChangePaymentStatus: widget.onChangePaymentStatus,
      );
    }
    return _OrderGrid(
      orders: widget.orders,
      loadMore: widget.loadMore,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
      crossAxisCount: 1,
      onChangeStatus: widget.onChangeStatus,
      onChangePaymentStatus: widget.onChangePaymentStatus,
    );
  }
}

// ============================================================
// SKELETON
// ============================================================

class _OrderSkeleton extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  const _OrderSkeleton({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).cardColor;

    if (isDesktop) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
        itemCount: 8,
        separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
        itemBuilder: (_, __) => Container(
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(context.radiusDefault),
          ),
        ),
      );
    }

    final crossAxisCount = isTablet ? 2 : 1;
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount == 1 ? 2.6 : 1.1,
        crossAxisSpacing: context.paddingSizeDefault,
        mainAxisSpacing: context.paddingSizeDefault,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.radiusLarge),
        ),
      ),
    );
  }
}

// ============================================================
// DESKTOP TABLE
// ============================================================

class _DesktopOrderTable extends ConsumerStatefulWidget {
  final List<OrderEntity> orders;
  final VoidCallback loadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;
  final Future<void> Function(OrderEntity, PaymentStatus) onChangePaymentStatus;

  const _DesktopOrderTable({
    required this.orders,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onChangeStatus,
    required this.onChangePaymentStatus,
  });

  @override
  ConsumerState<_DesktopOrderTable> createState() => _DesktopOrderTableState();
}

class _DesktopOrderTableState extends ConsumerState<_DesktopOrderTable> {
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
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      widget.loadMore();
    }
  }

  void _viewDetails(OrderEntity order) {
    context.pushNamed(
      AppRoutesName.adminOrderDetailsScreen,
      pathParameters: {'order_id': order.id},
    );
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
                  theme.colorScheme.surfaceContainerHighest.withAlpha(128),
                ),
                headingTextStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                dividerThickness: 0.6,
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Total'), numeric: true),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Payment')),
                  DataColumn(label: Text('')),
                ],
                rows: widget.orders.map((order) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        '#${order.id.substring(0, 8)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )),
                      DataCell(Text(order.userId)),
                      DataCell(Text(_formatDate(order.createdAt))),
                      DataCell(Text(
                        '৳${order.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )),
                      DataCell(
                        StatusChip(status: order.orderStatus.displayName, showDot: false),
                      ),
                      DataCell(_PaymentChip(status: order.paymentStatus)),
                      DataCell(_OrderActionsMenu(
                        order: order,
                        onView: _viewDetails,
                        onChangeStatus: widget.onChangeStatus,
                        onChangePaymentStatus: widget.onChangePaymentStatus,
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (widget.isLoadingMore)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

// ============================================================
// ORDER GRID
// ============================================================

class _OrderGrid extends StatefulWidget {
  final List<OrderEntity> orders;
  final VoidCallback loadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final int crossAxisCount;
  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;
  final Future<void> Function(OrderEntity, PaymentStatus) onChangePaymentStatus;

  const _OrderGrid({
    required this.orders,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.crossAxisCount,
    required this.onChangeStatus,
    required this.onChangePaymentStatus,
  });

  @override
  State<_OrderGrid> createState() => _OrderGridState();
}

class _OrderGridState extends State<_OrderGrid> {
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
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
      widget.loadMore();
    }
  }

  void _viewDetails(OrderEntity order) {
    context.pushNamed(
      AppRoutesName.adminOrderDetailsScreen,
      pathParameters: {'order_id': order.id},
    );
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
            itemCount: widget.orders.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => _OrderCard(
              order: widget.orders[index],
              onView: _viewDetails,
              onChangeStatus: widget.onChangeStatus,
              onChangePaymentStatus: widget.onChangePaymentStatus,
            ),
          )
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: 1.1,
              crossAxisSpacing: context.paddingSizeDefault,
              mainAxisSpacing: context.paddingSizeDefault,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _OrderCard(
                order: widget.orders[index],
                onView: _viewDetails,
                onChangeStatus: widget.onChangeStatus,
                onChangePaymentStatus: widget.onChangePaymentStatus,
              ),
              childCount: widget.orders.length,
            ),
          ),
        ),
        if (widget.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
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

// ============================================================
// ORDER CARD
// ============================================================

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final void Function(OrderEntity) onView;
  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;
  final Future<void> Function(OrderEntity, PaymentStatus) onChangePaymentStatus;

  const _OrderCard({
    required this.order,
    required this.onView,
    required this.onChangeStatus,
    required this.onChangePaymentStatus,
  });

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
      child: InkWell(
        onTap: () => onView(order),
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${order.id.substring(0, 8)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.fontSizeDefault,
                      ),
                    ),
                  ),
                  StatusChip(status: order.orderStatus.displayName, showDot: false),
                  _OrderActionsMenu(
                    order: order,
                    onView: onView,
                    onChangeStatus: onChangeStatus,
                    onChangePaymentStatus: onChangePaymentStatus,
                    compact: true,
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraSmall),
              Text(
                'Customer: ${order.userId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.fontSizeSmall,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: context.paddingSizeExtraSmall),
              Text(
                '৳${order.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: context.paddingSizeDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(order.createdAt),
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: context.fontSizeSmall,
                    ),
                  ),
                  _PaymentChip(status: order.paymentStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

// ============================================================
// ACTIONS MENU (shared by table + card)
// ============================================================

class _OrderActionsMenu extends StatelessWidget {
  final OrderEntity order;
  final void Function(OrderEntity) onView;
  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;
  final Future<void> Function(OrderEntity, PaymentStatus) onChangePaymentStatus;
  final bool compact;

  const _OrderActionsMenu({
    required this.order,
    required this.onView,
    required this.onChangeStatus,
    required this.onChangePaymentStatus,
    this.compact = false,
  });

  Color _paymentColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.refunded:
        return AppColors.archived;
      case PaymentStatus.processing:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: compact ? 20 : 22),
      padding: EdgeInsets.zero,
      tooltip: 'Order actions',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      onSelected: (value) async {
        if (value == 'view') {
          onView(order);
          return;
        }
        if (value.startsWith('status:')) {
          final statusValue = value.substring('status:'.length);
          final status =
          OrderStatus.values.firstWhere((s) => s.value == statusValue);
          await onChangeStatus(order, status);
        }
        if (value.startsWith('payment:')) {
          final statusName = value.substring('payment:'.length);
          final status =
          PaymentStatus.values.firstWhere((s) => s.name == statusName);
          await onChangePaymentStatus(order, status);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.visibility_outlined),
            title: Text('View Details'),
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem(
          enabled: false,
          child: Text(
            'Change Status',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ...OrderStatus.values.map((status) {
          final selected = order.orderStatus.value == status.value;
          return PopupMenuItem<String>(
            value: 'status:${status.value}',
            child: Row(
              children: [
                Icon(Icons.circle, size: 10, color: status.color),
                const SizedBox(width: 12),
                Expanded(child: Text(status.displayName)),
                if (selected) const Icon(Icons.check_rounded, size: 18),
              ],
            ),
          );
        }),
        const PopupMenuDivider(height: 8),
        PopupMenuItem(
          enabled: false,
          child: Text(
            'Change Payment',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
        ...PaymentStatus.values.map((status) {
          final selected = order.paymentStatus == status;
          return PopupMenuItem<String>(
            value: 'payment:${status.name}',
            child: Row(
              children: [
                Icon(Icons.circle, size: 10, color: _paymentColor(status)),
                const SizedBox(width: 12),
                Expanded(child: Text(status.name.toUpperCase())),
                if (selected) const Icon(Icons.check_rounded, size: 18),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ============================================================
// PAYMENT CHIP (order-specific, StatusChip doesn't cover payment status)
// ============================================================

class _PaymentChip extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentChip({required this.status});

  Color _color() {
    switch (status) {
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.refunded:
        return AppColors.archived;
      case PaymentStatus.processing:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingSizeExtraSmall + 2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(context.radiusSmall),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}