import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/usecases/validate_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/presentation/states/validate_coupon_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValidateCouponNotifier extends StateNotifier<ValidateCouponState> {
  final ValidateCouponUseCase _validateCouponUseCase;

  ValidateCouponNotifier(this._validateCouponUseCase)
    : super(const ValidateCouponState());

  Future<bool> validateCoupon({
    required String code,
    required double subtotal,
    required String userId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearCoupon: true,
      isValid: false,
    );

    try {
      final result = await _validateCouponUseCase(
        couponCode: code,
        subtotal: subtotal,
        userId: userId,
      );

      state = state.copyWith(isLoading: false, coupon: result, isValid: true);

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e, isValid: false);

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
        isValid: false,
      );

      return false;
    }
  }

  void clear() {
    state = const ValidateCouponState();
  }
}
