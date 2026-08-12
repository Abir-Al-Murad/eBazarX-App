import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';

abstract class CouponRepository {
  // ============================================================
  // VALIDATE COUPON
  // ============================================================

  Future<CouponValidationEntity> validateCoupon({
    required String couponCode,
    required double subtotal,
    required String userId,
  });

  // ============================================================
  // ADMIN - CREATE COUPON
  // ============================================================

  Future<AdminCouponEntity> createCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool isActive,
    required DateTime startDate,
    required DateTime endDate,
    String? sellerId,
    List<String>? productIds,
    List<String>? categoryIds,
  });

  // ============================================================
  // ADMIN - GET ALL COUPONS
  // ============================================================

  Future<List<AdminCouponEntity>> getAllCoupons({
    int skip = 0,
    int limit = 20,
  });

  // ============================================================
  // ADMIN - GET SINGLE COUPON
  // ============================================================

  Future<AdminCouponEntity> getCouponById({
    required String couponId,
  });

  // ============================================================
  // ADMIN - UPDATE COUPON
  // ============================================================

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
  });

  // ============================================================
  // ADMIN - DELETE COUPON
  // ============================================================

  Future<void> deleteCoupon({
    required String couponId,
  });

  // ============================================================
  // SELLER - CREATE COUPON
  // ============================================================

  Future<AdminCouponEntity> createSellerCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool isActive,
    required DateTime startDate,
    required DateTime endDate,
    List<String>? productIds,
    List<String>? categoryIds,
  });

  // ============================================================
  // SELLER - GET ALL COUPONS
  // ============================================================

  Future<List<AdminCouponEntity>> getSellerCoupons({
    int skip = 0,
    int limit = 20,
  });

  // ============================================================
  // SELLER - GET SINGLE COUPON
  // ============================================================

  Future<AdminCouponEntity> getSellerCouponById({
    required String couponId,
  });

  // ============================================================
  // SELLER - UPDATE COUPON
  // ============================================================

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
  });

  // ============================================================
  // SELLER - DELETE COUPON
  // ============================================================

  Future<void> deleteSellerCoupon({
    required String couponId,
  });
}