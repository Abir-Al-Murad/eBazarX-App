import 'package:ebazarx/admin/coupons/states/coupon_crud_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/usecases/create_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/delete_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_coupon_by_id_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/update_coupon_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponCrudNotifier extends StateNotifier<CouponCrudState> {
  final CreateCouponUseCase _createCouponUseCase;
  final GetCouponByIdUseCase _getCouponByIdUseCase;
  final UpdateCouponUseCase _updateCouponUseCase;
  final DeleteCouponUseCase _deleteCouponUseCase;

  CouponCrudNotifier({
    required CreateCouponUseCase createCouponUseCase,
    required GetCouponByIdUseCase getCouponByIdUseCase,
    required UpdateCouponUseCase updateCouponUseCase,
    required DeleteCouponUseCase deleteCouponUseCase,
  })  : _createCouponUseCase = createCouponUseCase,
        _getCouponByIdUseCase = getCouponByIdUseCase,
        _updateCouponUseCase = updateCouponUseCase,
        _deleteCouponUseCase = deleteCouponUseCase,
        super(const CouponCrudState());

  // ============================================================
  // CREATE
  // ============================================================

  Future<bool> createCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool isActive = true,
    required DateTime startDate,
    required DateTime endDate,
    String? sellerId,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    state = state.copyWith(
      status: CouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final coupon = await _createCouponUseCase(
        code: code,
        description: description,
        discountType: discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: isActive,
        startDate: startDate,
        endDate: endDate,
        sellerId: sellerId,
        productIds: productIds,
        categoryIds: categoryIds,
      );

      state = state.copyWith(
        status: CouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // GET SINGLE
  // ============================================================

  Future<bool> getCouponById(String couponId) async {
    state = state.copyWith(
      status: CouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final coupon = await _getCouponByIdUseCase(
        couponId: couponId,
      );

      state = state.copyWith(
        status: CouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<bool> updateCoupon({
    required String couponId,
    String? code,
    String? description,
    String? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    state = state.copyWith(
      status: CouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final coupon = await _updateCouponUseCase(
        couponId: couponId,
        code: code,
        description: description,
        discountType: discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: isActive,
        startDate: startDate,
        endDate: endDate,
        productIds: productIds,
        categoryIds: categoryIds,
      );

      state = state.copyWith(
        status: CouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<bool> deleteCoupon(String couponId) async {
    state = state.copyWith(
      status: CouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      await _deleteCouponUseCase(
        couponId: couponId,
      );

      state = state.copyWith(
        status: CouponCrudStatus.success,
        clearCoupon: true,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: CouponCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const CouponCrudState();
  }
}