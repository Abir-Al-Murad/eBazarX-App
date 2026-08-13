// seller/coupons/screens/seller_coupon_list_screen.dart
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/from_coupon_discount.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_card.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_dektop_table.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_grid.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/error_view.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/seller/coupons/providers/seller_coupon_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SellerCouponListScreen extends ConsumerStatefulWidget {
  const SellerCouponListScreen({super.key});

  @override
  ConsumerState<SellerCouponListScreen> createState() =>
      _SellerCouponListScreenState();
}

class _SellerCouponListScreenState extends ConsumerState<SellerCouponListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerCouponListNotifierProvider.notifier).loadCoupons();
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
      ref.read(sellerCouponListNotifierProvider.notifier).loadMoreCoupons();
    }
  }

  void _navigateToCreate() => context.push('/seller/coupons/create');

  void _navigateToEdit(String couponId) {
    context.pushNamed(AppRoutesName.sellerCouponForm, extra: couponId);
  }

  Future<void> _handleDelete(String couponId, String code) async {
    final notifier = ref.read(sellerCouponListNotifierProvider.notifier);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Delete Coupon',
        message: 'Are you sure you want to delete coupon "$code"? This action cannot be undone.',
        confirmLabel: 'Delete',
      ),
    );
    if (confirmed != true) return;

    final success =
    await ref.read(sellerCouponCrudNotifierProvider.notifier).deleteCoupon(couponId);
    if (success && mounted) {
      notifier.removeCoupon(couponId);
      AppSnackBar.success(context: context, 'Coupon deleted successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(sellerCouponListNotifierProvider);
    final notifier = ref.read(sellerCouponListNotifierProvider.notifier);

    ref.listen(sellerCouponCrudNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        notifier.refreshCoupons();
        if (next.coupon != null) {
          notifier.updateCouponLocally(next.coupon!);
        }
      }
      if (next.isFailure && next.failure != null) {
        AppSnackBar.error(context: context, next.failure!.message);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Coupons'),
        actions: [
          IconButton(
            onPressed: () => notifier.refreshCoupons(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          SizedBox(width: context.paddingSizeExtraSmall),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Coupon'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.paddingSizeDefault),
        child: _CouponBody(
          state: state,
          notifier: notifier,
          scrollController: _scrollController,
          onCreate: _navigateToCreate,
          onEdit: _navigateToEdit,
          onDelete: _handleDelete,
        ),
      ),
    );
  }
}

// ================================
// Body: loading / error / empty / responsive content
// ================================
class _CouponBody extends StatelessWidget {
  const _CouponBody({
    required this.state,
    required this.notifier,
    required this.scrollController,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  final dynamic state;
  final dynamic notifier;
  final ScrollController scrollController;
  final VoidCallback onCreate;
  final ValueChanged<String> onEdit;
  final void Function(String couponId, String code) onDelete;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.coupons.isEmpty) {
      return const LoadingContainer();
    }

    if (state.failure != null && state.coupons.isEmpty) {
      return ErrorView(failure: state.failure!, onRetry: () => notifier.loadCoupons());
    }

    if (state.coupons.isEmpty) {
      return EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'No coupons yet',
        message: 'Create your first coupon to attract more customers.',
        buttonText: 'Create Coupon',
        buttonIcon: Icons.add_rounded,
        onPressed: onCreate,
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refreshCoupons(),
      child: context.isDesktop
          ? CouponDesktopTable(
        scrollController: scrollController,
        hasMore: state.hasMore,
        rows: [
          for (final coupon in state.coupons)
            CouponTableRow(
              code: coupon.code,
              discountText: formatCouponDiscount(
                discountType: coupon.discountType,
                discountValue: coupon.discountValue,
              ),
              startDate: coupon.startDate,
              endDate: coupon.endDate,
              usedCount: coupon.usedCount,
              usageLimit: coupon.usageLimit,
              isActive: coupon.isActive,
              onEdit: () => onEdit(coupon.id),
              onDelete: () => onDelete(coupon.id, coupon.code),
            ),
        ],
      )
          : CouponGrid(
        scrollController: scrollController,
        hasMore: state.hasMore,
        crossAxisCount: context.isTablet ? 2 : 1,
        items: [
          for (final coupon in state.coupons)
            CouponCard(
              code: coupon.code,
              discountText: formatCouponDiscount(
                discountType: coupon.discountType,
                discountValue: coupon.discountValue,
              ),
              startDate: coupon.startDate,
              endDate: coupon.endDate,
              usedCount: coupon.usedCount,
              usageLimit: coupon.usageLimit,
              isActive: coupon.isActive,
              onEdit: () => onEdit(coupon.id),
              onDelete: () => onDelete(coupon.id, coupon.code),
            ),
        ],
      ),
    );
  }
}