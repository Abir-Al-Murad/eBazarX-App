import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/seller/orders/providers/seller_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/seller/orders/notifiers/seller_order_notifier.dart';
import 'package:ebazarx/seller/orders/states/seller_order_state.dart';
import 'package:ebazarx/seller/orders/widgets/seller_orders_header.dart';
import 'package:ebazarx/seller/orders/widgets/seller_statistics_cards.dart';
import 'package:ebazarx/seller/orders/widgets/seller_search_bar.dart';
import 'package:ebazarx/seller/orders/widgets/seller_filter_bar.dart';
import 'package:ebazarx/seller/orders/widgets/seller_bulk_action_bar.dart';
import 'package:ebazarx/seller/orders/widgets/seller_orders_list.dart';
import 'package:ebazarx/seller/orders/widgets/seller_empty_widget.dart';
import 'package:ebazarx/seller/orders/widgets/seller_error_widget.dart';
import 'package:ebazarx/seller/orders/widgets/seller_loading_skeleton.dart';
import 'package:ebazarx/seller/orders/widgets/seller_order_details_sheet.dart';

class SellerOrdersScreen extends ConsumerStatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  ConsumerState<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends ConsumerState<SellerOrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedIds = {}; // local selection state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerOrderNotifierProvider.notifier).getSellerOrders();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(sellerOrderNotifierProvider.notifier).loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerOrderNotifierProvider);
    final notifier = ref.read(sellerOrderNotifierProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:  EdgeInsets.all(context.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SellerOrdersHeader(onPressed: (){
                      ref.read(sellerOrderNotifierProvider.notifier).refresh();
                    },),
                    const SizedBox(height: 16),
                    SellerStatisticsCards(orders: state.items),
                    const SizedBox(height: 16),
                    const SellerSearchBar(),
                    const SizedBox(height: 8),
                    SellerFilterBar(
                      orderStatus: "All",
                      paymentStatus: "All",
                      sortBy: "Newest",
                      onOrderStatusChanged: (v) {},
                      onPaymentStatusChanged: (v) {},
                      onSortChanged: (v) {},
                      onDateRangePressed: () {},
                      onReset: () {},
                    ),
                    const SizedBox(height: 8),
                    if (_selectedIds.isNotEmpty)
                      SellerBulkActionBar(
                        selectedIds: _selectedIds,
                        onClearSelection: () => setState(() => _selectedIds.clear()),
                        onSelectAll: () {
                          setState(() {
                            if (_selectedIds.length == state.items.length) {
                              _selectedIds.clear();
                            } else {
                              _selectedIds.addAll(state.items.map((e) => e.id));
                            }
                          });
                        },
                        onBulkStatusUpdate: (status) {
                          notifier.updateMultipleOrders(
                            orderIds: _selectedIds.toList(),
                            status: status,
                          );
                        },
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: _buildContent(state, notifier),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SellerOrderState state, SellerOrderNotifier notifier) {
    if (state.isLoading && state.items.isEmpty) {
      return const SellerLoadingSkeleton();
    }

    if (state.failure != null && state.items.isEmpty) {
      return SellerErrorWidget(
        error: state.failure!.message,
        onRetry: () => notifier.getSellerOrders(),
      );
    }

    if (state.items.isEmpty && !state.isLoading) {
      return const SellerEmptyWidget();
    }

    return Column(
      children: [
        SellerOrdersList(
          orders: state.items,
          selectedIds: _selectedIds,
          onToggleSelection: (id) {
            setState(() {
              if (_selectedIds.contains(id)) {
                _selectedIds.remove(id);
              } else {
                _selectedIds.add(id);
              }
            });
          },
          onOrderTap: (order) => _showOrderDetails(context, order),
          onStatusChange: (orderId, status) {
            notifier.updateSellerOrderStatus(orderId: orderId, status: status);
          },
          updatingIds: state.updatingIds,
        ),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        if (!state.hasMore && state.items.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'No more orders',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  void _showOrderDetails(BuildContext context, OrderItemEntity order) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    if (isDesktop) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(40),
          child: SizedBox(
            width: 600,
            child: SellerOrderDetailsSheet(order: order),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) =>
              SellerOrderDetailsSheet(order: order),
        ),
      );
    }
  }
}