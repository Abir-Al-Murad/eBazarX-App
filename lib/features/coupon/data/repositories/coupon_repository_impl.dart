import 'package:ebazarx/features/coupon/data/datasources/coupon_remote_datasource.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDatasource _remoteDatasource;

  CouponRepositoryImpl(this._remoteDatasource);

  // ============================================================
  // VALIDATE COUPON
  // ============================================================

  @override
  Future<CouponValidationEntity> validateCoupon({
    required String couponCode,
    required double subtotal,
    required String userId,
  }) async {
    final model = await _remoteDatasource.validateCoupon(
      couponCode,
      subtotal,
      userId,
    );

    return model.toEntity();
  }

  // ============================================================
  // ADMIN - CREATE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> createCoupon({
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
    final model = await _remoteDatasource.createCoupon(
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

    return model.toEntity();
  }

  // ============================================================
  // ADMIN - GET ALL COUPONS
  // ============================================================

  @override
  Future<List<AdminCouponEntity>> getAllCoupons({
    int skip = 0,
    int limit = 20,
  }) async {
    final models = await _remoteDatasource.getAllCoupons(
      skip: skip,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  // ============================================================
  // ADMIN - GET SINGLE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> getCouponById({
    required String couponId,
  }) async {
    final model = await _remoteDatasource.getCouponById(couponId);

    return model.toEntity();
  }

  // ============================================================
  // ADMIN - UPDATE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> updateCoupon({
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
    final model = await _remoteDatasource.updateCoupon(
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

    return model.toEntity();
  }

  // ============================================================
  // ADMIN - DELETE COUPON
  // ============================================================

  @override
  Future<void> deleteCoupon({
    required String couponId,
  }) async {
    await _remoteDatasource.deleteCoupon(couponId);
  }

  // ============================================================
  // SELLER - CREATE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> createSellerCoupon({
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
    final model = await _remoteDatasource.createSellerCoupon(
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

    return model.toEntity();
  }

  // ============================================================
  // SELLER - GET ALL COUPONS
  // ============================================================

  @override
  Future<List<AdminCouponEntity>> getSellerCoupons({
    int skip = 0,
    int limit = 20,
  }) async {
    final models = await _remoteDatasource.getSellerCoupons(
      skip: skip,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  // ============================================================
  // SELLER - GET SINGLE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> getSellerCouponById({
    required String couponId,
  }) async {
    final model = await _remoteDatasource.getSellerCouponById(
      couponId,
    );

    return model.toEntity();
  }

  // ============================================================
  // SELLER - UPDATE COUPON
  // ============================================================

  @override
  Future<AdminCouponEntity> updateSellerCoupon({
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
    final model = await _remoteDatasource.updateSellerCoupon(
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

    return model.toEntity();
  }

  // ============================================================
  // SELLER - DELETE COUPON
  // ============================================================

  @override
  Future<void> deleteSellerCoupon({
    required String couponId,
  }) async {
    await _remoteDatasource.deleteSellerCoupon(couponId);
  }
}