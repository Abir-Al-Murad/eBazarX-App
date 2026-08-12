import 'package:ebazarx/seller/coupons/states/seller_coupon_crud_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/core/failures/failure.dart';

import 'package:ebazarx/features/coupon/domain/usecases/create_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_seller_coupon_by_id_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/update_seller_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/delete_seller_coupon_usecase.dart';


class SellerCouponCrudNotifier
    extends StateNotifier<SellerCouponCrudState> {
  final CreateSellerCouponUseCase _createSellerCoupon;
  final GetSellerCouponByIdUseCase _getSellerCouponById;
  final UpdateSellerCouponUseCase _updateSellerCoupon;
  final DeleteSellerCouponUseCase _deleteSellerCoupon;

  SellerCouponCrudNotifier({
    required CreateSellerCouponUseCase createSellerCoupon,
    required GetSellerCouponByIdUseCase getSellerCouponById,
    required UpdateSellerCouponUseCase updateSellerCoupon,
    required DeleteSellerCouponUseCase deleteSellerCoupon,
  })  : _createSellerCoupon = createSellerCoupon,
        _getSellerCouponById = getSellerCouponById,
        _updateSellerCoupon = updateSellerCoupon,
        _deleteSellerCoupon = deleteSellerCoupon,
        super(const SellerCouponCrudState());

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
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    state = state.copyWith(
      status: SellerCouponCrudStatus.loading,
      clearFailure: true,
      clearCoupon: true,
    );

    try {
      final coupon = await _createSellerCoupon(
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
        status: SellerCouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
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
      status: SellerCouponCrudStatus.loading,
      clearFailure: true,
      clearCoupon: true,
    );

    try {
      final coupon = await _getSellerCouponById(
        couponId: couponId,
      );

      state = state.copyWith(
        status: SellerCouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
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
      status: SellerCouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final coupon = await _updateSellerCoupon(
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
        status: SellerCouponCrudStatus.success,
        coupon: coupon,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
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
      status: SellerCouponCrudStatus.loading,
      clearFailure: true,
    );

    try {
      await _deleteSellerCoupon(
        couponId: couponId,
      );

      state = state.copyWith(
        status: SellerCouponCrudStatus.success,
        clearCoupon: true,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerCouponCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const SellerCouponCrudState();
  }
}