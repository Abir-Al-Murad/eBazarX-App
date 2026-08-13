// admin/coupons/screens/admin_coupon_list_screen.dart
import 'package:ebazarx/admin/coupons/providers/admin_coupon_providers.dart';
import 'package:ebazarx/admin/coupons/screens/admin_coupon_form_screen.dart';
import 'package:ebazarx/admin/coupons/states/coupon_list_state.dart';
import 'package:ebazarx/common/utils/from_coupon_discount.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_card.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_dektop_table.dart';
import 'package:ebazarx/common/widgets/coupon/coupon_grid.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminCouponListScreen extends ConsumerStatefulWidget {
  const AdminCouponListScreen({super.key});

  @override
  ConsumerState<AdminCouponListScreen> createState() =>
      _AdminCouponListScreenState();
}

class _AdminCouponListScreenState extends ConsumerState<AdminCouponListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(couponListNotifierProvider.notifier).getAllCoupons();
    });
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
      ref.read(couponListNotifierProvider.notifier).loadMoreCoupons();
    }
  }

  void _navigateToForm({AdminCouponEntity? coupon}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminCouponFormScreen(coupon: coupon)),
    ).then((_) {
      ref.read(couponListNotifierProvider.notifier).refresh();
    });
  }

  Future<void> _confirmDelete(String couponId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: 'Delete Coupon',
        message: 'Are you sure you want to delete this coupon? This action cannot be undone.',
        confirmLabel: 'Delete',
      ),
    );
    if (confirmed != true) return;

    final notifier = ref.read(couponCrudNotifierProvider.notifier);
    final success = await notifier.deleteCoupon(couponId);

    if (!mounted) return;
    if (success) {
      ref.read(couponListNotifierProvider.notifier).refresh();
      AppSnackBar.success(context: context, 'Coupon deleted');
    } else {
      AppSnackBar.error(context: context, 'Failed to delete coupon');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(couponListNotifierProvider);
    final notifier = ref.read(couponListNotifierProvider.notifier);

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
                      title: 'Coupons',
                      subtitle: 'Create and manage discount codes',
                    ),
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => notifier.refresh(),
                    tooltip: 'Refresh',
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  FilledButton.icon(
                    onPressed: () => _navigateToForm(),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New Coupon'),
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              Expanded(
                child: _CouponBody(
                  state: state,
                  notifier: notifier,
                  scrollController: _scrollController,
                  onEdit: (coupon) => _navigateToForm(coupon: coupon),
                  onDelete: (coupon) => _confirmDelete(coupon.id),
                  onAdd: () => _navigateToForm(),
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
class _CouponBody extends StatelessWidget {
  const _CouponBody({
    required this.state,
    required this.notifier,
    required this.scrollController,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  final CouponListState state;
  final dynamic notifier;
  final ScrollController scrollController;
  final ValueChanged<AdminCouponEntity> onEdit;
  final ValueChanged<AdminCouponEntity> onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.coupons.isEmpty) {
      return const LoadingContainer();
    }

    if (state.coupons.isEmpty) {
      return EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'No coupons yet',
        message: 'Create a coupon to offer discounts and drive more sales.',
        buttonText: 'New Coupon',
        buttonIcon: Icons.add_rounded,
        onPressed: onAdd,
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
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
              onEdit: () => onEdit(coupon),
              onDelete: () => onDelete(coupon),
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
              onEdit: () => onEdit(coupon),
              onDelete: () => onDelete(coupon),
            ),
        ],
      ),
    );
  }
}
