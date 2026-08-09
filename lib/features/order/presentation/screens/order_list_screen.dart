import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/common/widgets/go_to_login.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(orderListNotifierProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderListNotifierProvider);
    final theme = Theme.of(context);

    // Latest order first
    final orders = [...state.orders]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.paddingSizeDefault,
                context.paddingSizeDefault,
                context.paddingSizeDefault,
                context.paddingSizeSmall,
              ),
              child: Text(
                "My Orders",
                style: TextStyle(
                  fontSize: context.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(orderListNotifierProvider.notifier).refresh(),
                child: Builder(
                  builder: (_) {
                    if (!AuthStorage.instance.isLoggedIn) {
                      return GoToLogIn(
                        label: "Log in to view your orders.",
                        icon: Icons.production_quantity_limits,
                      );
                    }

                    if (state.isLoading && state.orders.isEmpty) {
                      return _OrderListShimmer(
                        crossAxisCount: context.responsive(
                          mobile: 1,
                          tablet: 2,
                          desktop: 3,
                        ),
                      );
                    }

                    if (state.failure != null && state.orders.isEmpty) {
                      return _ErrorState(
                        message: state.failure!.message,
                        onRetry: () => ref
                            .read(orderListNotifierProvider.notifier)
                            .loadOrders(),
                      );
                    }

                    if (orders.isEmpty) {
                      return const _EmptyState();
                    }

                    final crossAxisCount = context.responsive(
                      mobile: 1,
                      tablet: 2,
                      desktop: 3,
                    );

                    if (crossAxisCount == 1) {
                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(context.paddingSizeDefault),
                        itemCount: orders.length + 1,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: context.paddingSizeSmall),
                        itemBuilder: (_, index) {
                          if (index == orders.length) {
                            return const SizedBox(height: 100);
                          }
                          return _OrderCard(order: orders[index]);
                        },
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(context.paddingSizeDefault),
                      itemCount: orders.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: context.paddingSizeSmall,
                        crossAxisSpacing: context.paddingSizeSmall,
                        mainAxisExtent: 220,
                      ),
                      itemBuilder: (_, index) =>
                          _OrderCard(order: orders[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderCard({required this.order});

  Color _statusColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (order.orderStatus.name) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return theme.colorScheme.primary;
      case 'shipped':
        return theme.colorScheme.tertiary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _statusIcon() {
    switch (order.orderStatus.name) {
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'processing':
        return Icons.autorenew_rounded;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.check_circle_outline_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(context);
    final items = order.items;
    final firstItem = items.isNotEmpty ? items.first : null;
    final extraCount = items.length > 1 ? items.length - 1 : 0;

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(context.radiusLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.radiusLarge),
        onTap: () {
          context.pushNamed(AppRoutesName.orderDetails,pathParameters: {"order_id":order.id});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusLarge),
            border: Border.all(color: theme.dividerColor),
          ),
          padding: EdgeInsets.all(context.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius:
                      BorderRadius.circular(context.radiusDefault),
                    ),
                    child: Icon(_statusIcon(), size: 18, color: color),
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #${order.id.substring(0, 8)}",
                          style: TextStyle(
                            fontSize: context.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}",
                          style: TextStyle(
                            fontSize: context.fontSizeSmall,
                            fontWeight: FontWeight.normal,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.paddingSizeSmall,
                      vertical: context.paddingSizeExtraSmall / 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius:
                      BorderRadius.circular(context.radiusDefault),
                    ),
                    child: Text(
                      order.orderStatus.name.toUpperCase(),
                      style: context.bold.copyWith(
                        fontSize: context.fontSizeSmall,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                  height: context.paddingSizeLarge, color: theme.dividerColor),
              if (firstItem != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(context.radiusDefault),
                      child: firstItem.productImageAtTime != null &&
                          firstItem.productImageAtTime!.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: firstItem.productImageAtTime!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 44,
                          height: 44,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 44,
                          height: 44,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 18, color: theme.hintColor),
                        ),
                      )
                          : Container(
                        width: 44,
                        height: 44,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.inventory_2_outlined,
                            size: 18, color: theme.hintColor),
                      ),
                    ),
                    SizedBox(width: context.paddingSizeSmall),
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: context.regular.copyWith(
                            fontSize: context.fontSizeSmall,
                            color: theme.colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(text: firstItem.productNameAtTime),
                            TextSpan(
                              text: "  x${firstItem.quantity}",
                              style: context.medium.copyWith(
                                fontSize: context.fontSizeSmall,
                                color: theme.hintColor,
                              ),
                            ),
                            if (extraCount > 0)
                              TextSpan(
                                text: "   +$extraCount more",
                                style: context.medium.copyWith(
                                  fontSize: context.fontSizeExtraSmall,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: context.paddingSizeSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 16, color: theme.hintColor),
                      SizedBox(width: context.paddingSizeExtraSmall),
                      Text(
                        "${items.length} Item${items.length > 1 ? 's' : ''}",
                        style: context.regular.copyWith(
                          fontSize: context.fontSizeSmall,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "৳ ${order.grandTotal.toStringAsFixed(2)}",
                    style: context.bold.copyWith(
                      fontSize: context.fontSizeLarge,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderListShimmer extends StatelessWidget {
  final int crossAxisCount;

  const _OrderListShimmer({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget skeletonCard() => Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        padding: EdgeInsets.all(context.paddingSizeDefault),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(context.radiusLarge),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius:
                    BorderRadius.circular(context.radiusDefault),
                  ),
                ),
                SizedBox(width: context.paddingSizeSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 120, color: theme.cardColor),
                      SizedBox(height: context.paddingSizeExtraSmall),
                      Container(height: 10, width: 80, color: theme.cardColor),
                    ],
                  ),
                ),
                Container(height: 22, width: 60, color: theme.cardColor),
              ],
            ),
            SizedBox(height: context.paddingSizeLarge),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius:
                    BorderRadius.circular(context.radiusDefault),
                  ),
                ),
                SizedBox(width: context.paddingSizeSmall),
                Expanded(
                  child: Container(
                      height: 14, width: double.infinity, color: theme.cardColor),
                ),
              ],
            ),
            SizedBox(height: context.paddingSizeSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 14, width: 70, color: theme.cardColor),
                Container(height: 18, width: 90, color: theme.cardColor),
              ],
            ),
          ],
        ),
      ),
    );

    if (crossAxisCount == 1) {
      return ListView.separated(
        padding: EdgeInsets.all(context.paddingSizeDefault),
        itemCount: 6,
        separatorBuilder: (_, __) =>
            SizedBox(height: context.paddingSizeSmall),
        itemBuilder: (_, __) => skeletonCard(),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(context.paddingSizeDefault),
      itemCount: crossAxisCount * 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: context.paddingSizeSmall,
        crossAxisSpacing: context.paddingSizeSmall,
        mainAxisExtent: 220,
      ),
      itemBuilder: (_, __) => skeletonCard(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.paddingSizeDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: theme.hintColor),
            SizedBox(height: context.paddingSizeDefault),
            Text(
              "No orders found",
              style: context.regular.copyWith(
                fontSize: context.fontSizeDefault,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.paddingSizeExtraSmall),
            Text(
              "Your placed orders will show up here.",
              style: context.regular.copyWith(
                fontSize: context.fontSizeSmall,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.paddingSizeDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
            SizedBox(height: context.paddingSizeDefault),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.regular.copyWith(
                fontSize: context.fontSizeDefault,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.paddingSizeDefault),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}