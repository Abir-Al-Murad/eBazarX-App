import 'package:ebazarx/admin/coupons/notifiers/coupon_crud_notifier.dart';
import 'package:ebazarx/admin/coupons/notifiers/coupon_list_notifier.dart';
import 'package:ebazarx/admin/coupons/states/coupon_crud_state.dart';
import 'package:ebazarx/admin/coupons/states/coupon_list_state.dart';

import 'package:ebazarx/features/coupon/presentation/providers/coupon_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final couponListNotifierProvider =
    StateNotifierProvider<CouponListNotifier, CouponListState>(
      (ref) => CouponListNotifier(ref.read(getAllCouponsUseCaseProvider)),
    );

final couponCrudNotifierProvider =
    StateNotifierProvider<CouponCrudNotifier, CouponCrudState>(
      (ref) => CouponCrudNotifier(
        createCouponUseCase: ref.read(createCouponUseCaseProvider),
        getCouponByIdUseCase: ref.read(getCouponByIdUseCaseProvider),
        updateCouponUseCase: ref.read(updateCouponUseCaseProvider),
        deleteCouponUseCase: ref.read(deleteCouponUseCaseProvider),
      ),
    );
