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

  Future<List<AdminCouponEntity>> getAllCoupons({int skip, int limit});

  // ============================================================
  // ADMIN - GET SINGLE COUPON
  // ============================================================

  Future<AdminCouponEntity> getCouponById({required String couponId});

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

  Future<void> deleteCoupon({required String couponId});
}
