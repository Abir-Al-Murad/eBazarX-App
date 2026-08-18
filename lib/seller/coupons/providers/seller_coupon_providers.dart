import 'package:ebazarx/features/coupon/domain/usecases/create_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/delete_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_seller_coupon_by_id_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/update_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/presentation/providers/coupon_providers.dart';
import 'package:ebazarx/seller/coupons/notifiers/seller_coupon_crud_notifier.dart';
import 'package:ebazarx/seller/coupons/notifiers/seller_coupon_list_notifier.dart';
import 'package:ebazarx/seller/coupons/states/seller_coupon_crud_state.dart';
import 'package:ebazarx/seller/coupons/states/seller_coupon_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createSellerCouponUseCaseProvider = Provider<CreateSellerCouponUseCase>((
  ref,
) {
  return CreateSellerCouponUseCase(ref.read(couponRepositoryProvider));
});

// ------------------------------------------------------------
// GET ALL
// ------------------------------------------------------------

final getSellerCouponsUseCaseProvider = Provider<GetSellerCouponsUseCase>((
  ref,
) {
  return GetSellerCouponsUseCase(ref.read(couponRepositoryProvider));
});

// ------------------------------------------------------------
// GET SINGLE
// ------------------------------------------------------------

final getSellerCouponByIdUseCaseProvider = Provider<GetSellerCouponByIdUseCase>(
  (ref) {
    return GetSellerCouponByIdUseCase(ref.read(couponRepositoryProvider));
  },
);

// ------------------------------------------------------------
// UPDATE
// ------------------------------------------------------------

final updateSellerCouponUseCaseProvider = Provider<UpdateSellerCouponUseCase>((
  ref,
) {
  return UpdateSellerCouponUseCase(ref.read(couponRepositoryProvider));
});

// ------------------------------------------------------------
// DELETE
// ------------------------------------------------------------

final deleteSellerCouponUseCaseProvider = Provider<DeleteSellerCouponUseCase>((
  ref,
) {
  return DeleteSellerCouponUseCase(ref.read(couponRepositoryProvider));
});

// ============================================================
// LIST NOTIFIER
// ============================================================

final sellerCouponListNotifierProvider =
    StateNotifierProvider<SellerCouponListNotifier, SellerCouponListState>((
      ref,
    ) {
      return SellerCouponListNotifier(
        ref.read(getSellerCouponsUseCaseProvider),
      );
    });

// ============================================================
// CRUD NOTIFIER
// ============================================================

final sellerCouponCrudNotifierProvider =
    StateNotifierProvider<SellerCouponCrudNotifier, SellerCouponCrudState>((
      ref,
    ) {
      return SellerCouponCrudNotifier(
        createSellerCoupon: ref.read(createSellerCouponUseCaseProvider),

        getSellerCouponById: ref.read(getSellerCouponByIdUseCaseProvider),

        updateSellerCoupon: ref.read(updateSellerCouponUseCaseProvider),

        deleteSellerCoupon: ref.read(deleteSellerCouponUseCaseProvider),
      );
    });
