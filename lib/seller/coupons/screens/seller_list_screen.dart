import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/seller/coupons/providers/seller_coupon_providers.dart';
import 'package:ebazarx/seller/coupons/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SellerCouponListScreen extends ConsumerStatefulWidget {
  const SellerCouponListScreen({super.key});

  @override
  ConsumerState<SellerCouponListScreen> createState() =>
      _SellerCouponListScreenState();
}

class _SellerCouponListScreenState
    extends ConsumerState<SellerCouponListScreen> {
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
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(sellerCouponListNotifierProvider.notifier).loadMoreCoupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerCouponListNotifierProvider);
    final notifier = ref.read(sellerCouponListNotifierProvider.notifier);

    ref.listen(sellerCouponCrudNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        // Refresh list after successful CRUD operation
        notifier.refreshCoupons();
        if (next.coupon != null) {
          // We updated the coupon, update locally if possible
          notifier.updateCouponLocally(next.coupon!);
        }
      }
      if (next.isFailure && next.failure != null) {
        AppSnackBar.error(
          context: context,
          next.failure!.message,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coupons'),
        actions: [
          IconButton(
            onPressed: () => notifier.refreshCoupons(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/seller/coupons/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Coupon'),
      ),
      body: state.isLoading && state.coupons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.failure != null && state.coupons.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(state.failure!.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadCoupons(),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : state.coupons.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No coupons yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first coupon to attract more customers',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/seller/coupons/create');
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Coupon'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () => notifier.refreshCoupons(),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.coupons.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.coupons.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final coupon = state.coupons[index];
            return CouponCard(
              coupon: coupon,
              onEdit: () {
                context.pushNamed(
                  AppRoutesName.sellerCouponForm,
                  extra: coupon.id
                );
              },
              onDelete: () async {
                final confirmed = await _showDeleteDialog(
                  context,
                  coupon.code,
                );
                if (confirmed == true) {
                  final success = await ref
                      .read(sellerCouponCrudNotifierProvider
                      .notifier)
                      .deleteCoupon(coupon.id);
                  if (success) {
                    notifier.removeCoupon(coupon.id);
                    AppSnackBar.success(
                      context: context,
                      'Coupon deleted successfully',
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, String code) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coupon'),
        content: Text('Are you sure you want to delete coupon "$code"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}