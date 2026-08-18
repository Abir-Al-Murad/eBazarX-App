import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/seller/coupons/providers/seller_coupon_providers.dart';
import 'package:ebazarx/seller/coupons/widgets/coupon_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SellerCouponFormScreen extends ConsumerStatefulWidget {
  final String? couponId; // If provided, edit mode

  const SellerCouponFormScreen({super.key, this.couponId});

  @override
  ConsumerState<SellerCouponFormScreen> createState() =>
      _SellerCouponFormScreenState();
}

class _SellerCouponFormScreenState
    extends ConsumerState<SellerCouponFormScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.couponId != null) {
      Future.microtask(() {
        ref
            .read(sellerCouponCrudNotifierProvider.notifier)
            .getCouponById(widget.couponId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crudState = ref.watch(sellerCouponCrudNotifierProvider);
    final crudNotifier = ref.read(sellerCouponCrudNotifierProvider.notifier);

    ref.listen(sellerCouponCrudNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        if (widget.couponId != null) {
          AppSnackBar.success(
            context: context,
            'Coupon updated successfully',
          );
        } else {
          AppSnackBar.success(
            context: context,
            'Coupon created successfully',
          );
        }
        context.pop();
      }
      if (next.isFailure && next.failure != null) {
        AppSnackBar.error(
          context: context,
          next.failure!.message,
        );
      }
    });

    final coupon = crudState.coupon;
    final isEditing = widget.couponId != null;
    final isLoading = crudState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Coupon' : 'Create Coupon'),
      ),
      body: isLoading && isEditing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CouponForm(
          initialData: coupon,
          isEditing: isEditing,
          onSubmit: (data) async {
            bool success;
            if (isEditing) {
              success = await crudNotifier.updateCoupon(
                couponId: widget.couponId!,
                code: data['code'],
                description: data['description'],
                discountType: data['discountType'],
                discountValue: data['discountValue'],
                minOrderAmount: data['minOrderAmount'],
                maxDiscount: data['maxDiscount'],
                usageLimit: data['usageLimit'],
                perUserLimit: data['perUserLimit'],
                isActive: data['isActive'],
                startDate: data['startDate'],
                endDate: data['endDate'],
              );
            } else {
              success = await crudNotifier.createCoupon(
                code: data['code'],
                description: data['description'],
                discountType: data['discountType'],
                discountValue: data['discountValue'],
                minOrderAmount: data['minOrderAmount'],
                maxDiscount: data['maxDiscount'],
                usageLimit: data['usageLimit'],
                perUserLimit: data['perUserLimit'],
                isActive: data['isActive'],
                startDate: data['startDate'],
                endDate: data['endDate'],
              );
            }
            if (!success) {
              // Error handled by listener
            }
          },
          onCancel: () => context.pop(),
          isSubmitting: crudState.isLoading,
        ),
      ),
    );
  }
}