// admin/coupons/screens/coupon_list_screen.dart
import 'package:ebazarx/admin/coupons/providers/admin_coupon_providers.dart';
import 'package:ebazarx/admin/coupons/screens/admin_coupon_form_screen.dart';
import 'package:ebazarx/admin/coupons/states/coupon_list_state.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminCouponListScreen extends ConsumerStatefulWidget {
  const AdminCouponListScreen({super.key});

  @override
  ConsumerState<AdminCouponListScreen> createState() =>
      _AdminCouponListScreenState();
}

class _AdminCouponListScreenState
    extends ConsumerState<AdminCouponListScreen> {
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
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(couponListNotifierProvider.notifier).loadMoreCoupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(couponListNotifierProvider);
    final notifier = ref.read(couponListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToForm(context),
          ),
        ],
      ),
      body: state.isLoading && state.coupons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.coupons.isEmpty
          ? const Center(child: Text('No coupons found'))
          : RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: state.coupons.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.coupons.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final coupon = state.coupons[index];
            return _CouponTile(
              coupon: coupon,
              onEdit: () => _navigateToForm(context, coupon: coupon),
              onDelete: () => _confirmDelete(context, coupon.id),
            );
          },
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, {AdminCouponEntity? coupon}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminCouponFormScreen(coupon: coupon),
      ),
    ).then((_) {
      ref.read(couponListNotifierProvider.notifier).refresh();
    });
  }

  void _confirmDelete(BuildContext context, String couponId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Coupon'),
        content: const Text('Are you sure you want to delete this coupon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final notifier =
              ref.read(couponCrudNotifierProvider.notifier);
              final success = await notifier.deleteCoupon(couponId);
              if (success) {
                ref.read(couponListNotifierProvider.notifier).refresh();
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete coupon')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CouponTile extends StatelessWidget {
  final AdminCouponEntity coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CouponTile({
    required this.coupon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final discountText = coupon.discountType == 'percentage'
        ? '${coupon.discountValue.toStringAsFixed(0)}%'
        : '\$${coupon.discountValue.toStringAsFixed(2)}';

    final dateFormat = DateFormat('yyyy-MM-dd');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(coupon.code),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discount: $discountText'),
            Text(
              'Valid: ${dateFormat.format(coupon.startDate)} → ${dateFormat.format(coupon.endDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Used: ${coupon.usedCount} / ${coupon.usageLimit ?? "∞"}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        leading: coupon.isActive
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}