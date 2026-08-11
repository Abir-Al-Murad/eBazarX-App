import 'package:ebazarx/admin/orders/providers/admin_order_providers.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/styles.dart';
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

  bool _showSearch = false;

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

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshAll() async {
    await ref.read(adminOrdersListProvider.notifier).getAllOrders();
  }

  // ============================================================
  // CHANGE STATUS
  // ============================================================

  Future<void> _changeOrderStatus(OrderEntity order, OrderStatus status) async {
    // Already same status
    if (order.orderStatus.value == status.value) {
      return;
    }

    try {
      // First update backend
      await ref
          .read(adminOrderProvider.notifier)
          .updateOrderStatus(order.id, status.value);

      // IMPORTANT:
      // adminOrderProvider and adminOrdersListProvider
      // are separate providers.
      //
      // So after updating the backend, reload the list provider
      // to get the latest OrderEntity.
      await ref.read(adminOrdersListProvider.notifier).getAllOrders();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status changed to ${status.displayName}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminOrdersListProvider);

    final orders = state.items;

    final query = _searchController.text.trim().toLowerCase();

    bool matchesQuery(OrderEntity order) {
      return query.isEmpty ||
          order.id.toLowerCase().contains(query) ||
          order.userId.toLowerCase().contains(query);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) {
                  setState(() {});
                },
                style: context.bold.copyWith(
                  fontSize: context.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search by order ID or customer...',
                  border: InputBorder.none,
                ),
              )
            : const Text('Order Management'),

        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;

                if (!_showSearch) {
                  _searchController.clear();
                }
              });
            },
          ),

          if (context.isDesktop)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshAll),
        ],

        // ========================================================
        // TABS
        // ========================================================
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),

          child: Container(
            color:
                Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,

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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(context.radiusLarge),
              ),

              indicatorSize: TabBarIndicatorSize.tab,

              dividerColor: Colors.transparent,

              labelColor: Theme.of(context).colorScheme.onPrimary,

              unselectedLabelColor: Theme.of(
                context,
              ).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),

              labelStyle: TextStyle(
                fontSize: context.fontSizeSmall,
                fontWeight: FontWeight.w700,
              ),

              unselectedLabelStyle: TextStyle(
                fontSize: context.fontSizeSmall,
                fontWeight: FontWeight.w500,
              ),

              labelPadding: EdgeInsets.symmetric(
                horizontal: context.paddingSizeDefault,
              ),

              tabs: [
                // ALL
                Tab(text: 'All (${orders.length})'),

                // STATUS TABS
                ..._statuses.map((status) {
                  final count = orders
                      .where((order) => order.orderStatus.value == status.value)
                      .length;

                  return Tab(text: '${status.displayName} ($count)');
                }),
              ],
            ),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: RefreshIndicator(
        onRefresh: _refreshAll,

        child: TabBarView(
          controller: _tabController,

          children: [
            // ====================================================
            // ALL ORDERS
            // ====================================================
            _OrderPanel(
              orders: orders.where(matchesQuery).toList(),

              isLoading: state.isLoading,

              isLoadingMore: state.isLoadingMore,

              hasMore: state.hasMore,

              failure: state.failure,

              onRetry: _refreshAll,

              loadMore: () {
                ref.read(adminOrdersListProvider.notifier).loadMoreOrders();
              },

              onChangeStatus: _changeOrderStatus,
            ),

            // ====================================================
            // STATUS ORDERS
            // ====================================================
            ..._statuses.map((status) {
              return _OrderPanel(
                orders: orders
                    .where((order) => order.orderStatus.value == status.value)
                    .where(matchesQuery)
                    .toList(),

                isLoading: state.isLoading,

                isLoadingMore: state.isLoadingMore,

                hasMore: state.hasMore,

                failure: state.failure,

                onRetry: _refreshAll,

                loadMore: () {
                  ref.read(adminOrdersListProvider.notifier).loadMoreOrders();
                },

                onChangeStatus: _changeOrderStatus,
              );
            }),
          ],
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

  final Object? failure;

  final VoidCallback onRetry;
  final VoidCallback loadMore;

  final Future<void> Function(OrderEntity, OrderStatus) onChangeStatus;

  const _OrderPanel({
    required this.orders,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.failure,
    required this.onRetry,
    required this.loadMore,
    required this.onChangeStatus,
  });

  @override
  State<_OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<_OrderPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // ==========================================================
    // LOADING
    // ==========================================================

    if (widget.isLoading && widget.orders.isEmpty) {
      return _OrderSkeleton(
        isDesktop: context.isDesktop,
        isTablet: context.isTablet,
      );
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    if (widget.failure != null && widget.orders.isEmpty) {
      return _ErrorState(
        message: widget.failure.toString(),
        onRetry: widget.onRetry,
      );
    }

    // ==========================================================
    // EMPTY
    // ==========================================================

    if (widget.orders.isEmpty) {
      return const _EmptyState();
    }

    // ==========================================================
    // DESKTOP
    // ==========================================================

    if (context.isDesktop) {
      return _DesktopOrderTable(
        orders: widget.orders,
        loadMore: widget.loadMore,
        hasMore: widget.hasMore,
        isLoadingMore: widget.isLoadingMore,
        onChangeStatus: widget.onChangeStatus,
      );
    }

    // ==========================================================
    // TABLET
    // ==========================================================

    if (context.isTablet) {
      return _OrderGrid(
        orders: widget.orders,
        loadMore: widget.loadMore,
        hasMore: widget.hasMore,
        isLoadingMore: widget.isLoadingMore,
        crossAxisCount: 2,
        onChangeStatus: widget.onChangeStatus,
      );
    }

    // ==========================================================
    // MOBILE
    // ==========================================================

    return _OrderGrid(
      orders: widget.orders,
      loadMore: widget.loadMore,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
      crossAxisCount: 1,
      onChangeStatus: widget.onChangeStatus,
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeLarge),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Theme.of(context).disabledColor,
              ),

              SizedBox(height: context.paddingSizeDefault),

              Text(
                'No orders found',
                style: TextStyle(
                  fontSize: context.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
// ERROR STATE
// ============================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeLarge),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.error,
              ),

              SizedBox(height: context.paddingSizeSmall),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),

              SizedBox(height: context.paddingSizeDefault),

              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
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
        padding: EdgeInsets.all(context.paddingSizeDefault),

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
      padding: EdgeInsets.all(context.paddingSizeDefault),

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

  const _DesktopOrderTable({
    required this.orders,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onChangeStatus,
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

  // ==========================================================
  // LOAD MORE
  // ==========================================================

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore) {
      return;
    }

    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (widget.hasMore && !widget.isLoadingMore) {
          widget.loadMore();
        }
      });
    }
  }

  // ==========================================================
  // VIEW DETAILS
  // ==========================================================

  void _viewDetails(OrderEntity order) {
    context.pushNamed(
      AppRoutesName.adminOrderDetailsScreen,

      pathParameters: {'order_id': order.id},
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      controller: _scrollController,

      padding: EdgeInsets.all(context.paddingSizeDefault),

      child: Card(
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radiusLarge),

          side: BorderSide(color: theme.dividerColor),
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          children: [
            SizedBox(
              width: double.infinity,

              child: DataTable(
                columnSpacing: 20,

                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest,
                ),

                columns: const [
                  DataColumn(label: Text('Order ID')),

                  DataColumn(label: Text('Customer')),

                  DataColumn(label: Text('Date')),

                  DataColumn(label: Text('Total')),

                  DataColumn(label: Text('Status')),

                  DataColumn(label: Text('Payment')),

                  DataColumn(label: Text('Actions')),
                ],

                rows: widget.orders.map((order) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${order.id.substring(0, 8)}')),

                      DataCell(Text(order.userId)),

                      DataCell(Text(_formatDate(order.createdAt))),

                      DataCell(
                        Text('\$${order.grandTotal.toStringAsFixed(2)}'),
                      ),

                      DataCell(_OrderStatusChip(status: order.orderStatus)),

                      DataCell(_PaymentChip(status: order.paymentStatus)),

                      DataCell(
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),

                          tooltip: 'Order actions',

                          onSelected: (value) async {
                            // VIEW
                            if (value == 'view') {
                              _viewDetails(order);
                              return;
                            }

                            // STATUS
                            if (value.startsWith('status:')) {
                              final valueString = value.substring(
                                'status:'.length,
                              );

                              final status = OrderStatus.values.firstWhere(
                                (item) => item.value == valueString,
                              );

                              await widget.onChangeStatus(order, status);
                            }
                          },

                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'view',

                                child: Row(
                                  children: [
                                    Icon(Icons.visibility_outlined),

                                    SizedBox(width: 12),

                                    Text('View Details'),
                                  ],
                                ),
                              ),

                              const PopupMenuDivider(),

                              PopupMenuItem<String>(
                                enabled: false,

                                child: Text(
                                  'Change Status',

                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,

                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),

                              ...OrderStatus.values.map((status) {
                                final selected =
                                    order.orderStatus.value == status.value;

                                return PopupMenuItem<String>(
                                  value: 'status:${status.value}',

                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: status.color,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(child: Text(status.displayName)),

                                      if (selected)
                                        const Icon(Icons.check, size: 18),
                                    ],
                                  ),
                                );
                              }),
                            ];
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            if (widget.isLoadingMore)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.paddingSizeDefault,
                ),

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
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

  const _OrderGrid({
    required this.orders,
    required this.loadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.crossAxisCount,
    required this.onChangeStatus,
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

  // ==========================================================
  // LOAD MORE
  // ==========================================================

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore) {
      return;
    }

    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (widget.hasMore && !widget.isLoadingMore) {
          widget.loadMore();
        }
      });
    }
  }

  // ==========================================================
  // VIEW DETAILS
  // ==========================================================

  void _viewDetails(OrderEntity order) {
    context.pushNamed(
      AppRoutesName.adminOrderDetailsScreen,

      pathParameters: {'order_id': order.id},
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,

      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(context.paddingSizeDefault),

          sliver: widget.crossAxisCount == 1
              ? SliverList.separated(
                  itemCount: widget.orders.length,

                  separatorBuilder: (_, __) =>
                      SizedBox(height: context.paddingSizeSmall),

                  itemBuilder: (context, index) {
                    return _OrderCard(
                      order: widget.orders[index],

                      onView: _viewDetails,

                      onChangeStatus: widget.onChangeStatus,
                    );
                  },
                )
              : SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,

                    childAspectRatio: 1.1,

                    crossAxisSpacing: context.paddingSizeDefault,

                    mainAxisSpacing: context.paddingSizeDefault,
                  ),

                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _OrderCard(
                      order: widget.orders[index],

                      onView: _viewDetails,

                      onChangeStatus: widget.onChangeStatus,
                    );
                  }, childCount: widget.orders.length),
                ),
        ),

        if (widget.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.paddingSizeDefault,
              ),

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

  const _OrderCard({
    required this.order,
    required this.onView,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusLarge),

        side: BorderSide(color: theme.dividerColor),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: () {
          onView(order);
        },

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

                  _OrderStatusChip(status: order.orderStatus),

                  // ==================================================
                  // 3 DOT MENU
                  // ==================================================
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),

                    tooltip: 'Order actions',

                    onSelected: (value) async {
                      // VIEW
                      if (value == 'view') {
                        onView(order);
                        return;
                      }

                      // STATUS
                      if (value.startsWith('status:')) {
                        final statusValue = value.substring('status:'.length);

                        final status = OrderStatus.values.firstWhere(
                          (item) => item.value == statusValue,
                        );

                        await onChangeStatus(order, status);
                      }
                    },

                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'view',

                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined),

                              SizedBox(width: 12),

                              Text('View Details'),
                            ],
                          ),
                        ),

                        const PopupMenuDivider(),

                        PopupMenuItem<String>(
                          enabled: false,

                          child: Text(
                            'Change Status',

                            style: TextStyle(
                              fontWeight: FontWeight.w700,

                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),

                        ...OrderStatus.values.map((status) {
                          final selected =
                              order.orderStatus.value == status.value;

                          return PopupMenuItem<String>(
                            value: 'status:${status.value}',

                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: status.color,
                                ),

                                const SizedBox(width: 12),

                                Expanded(child: Text(status.displayName)),

                                if (selected) const Icon(Icons.check, size: 18),
                              ],
                            ),
                          );
                        }),
                      ];
                    },
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

                  color: theme.hintColor,
                ),
              ),

              SizedBox(height: context.paddingSizeExtraSmall),

              Text(
                '\$${order.grandTotal.toStringAsFixed(2)}',

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
                      color: theme.hintColor,

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ============================================================
// ORDER STATUS CHIP
// ============================================================

class _OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingSizeExtraSmall + 2,

        vertical: 3,
      ),

      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),

        borderRadius: BorderRadius.circular(context.radiusSmall),
      ),

      child: Text(
        status.displayName.toUpperCase(),

        style: TextStyle(
          color: status.color,

          fontWeight: FontWeight.bold,

          fontSize: 10,
        ),
      ),
    );
  }
}

// ============================================================
// PAYMENT CHIP
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
        return Colors.grey;

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
        color: color.withValues(alpha: 0.12),

        borderRadius: BorderRadius.circular(context.radiusSmall),
      ),

      child: Text(
        status.name.toUpperCase(),

        style: TextStyle(
          color: color,

          fontWeight: FontWeight.bold,

          fontSize: 10,
        ),
      ),
    );
  }
}
