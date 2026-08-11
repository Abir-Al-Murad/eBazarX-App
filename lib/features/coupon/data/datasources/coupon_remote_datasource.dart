import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/coupon/data/models/admin_coupon_model.dart';
import 'package:ebazarx/features/coupon/data/models/coupon_validation_model.dart';

class CouponRemoteDatasource {
  final ApiClient _apiClient;

  CouponRemoteDatasource(this._apiClient);

  // ============================================================
  // VALIDATE COUPON
  // POST /coupons/validate
  // ============================================================

  Future<CouponValidationModel> validateCoupon(
    String couponCode,
    double subTotal,
    String userId,
  ) async {
    final response = await _apiClient.post(
      '/coupons/validate',
      data: {'code': couponCode, 'subtotal': subTotal, 'user_id': userId},
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to validate coupon');
    }

    return CouponValidationModel.fromJson(response.body);
  }

  // ============================================================
  // CREATE COUPON
  // POST /admin/coupons/
  // ============================================================

  Future<AdminCouponModel> createCoupon({
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
    final response = await _apiClient.post(
      '/admin/coupons/',
      data: {
        'code': code,
        'description': description,
        'discount_type': discountType,
        'discount_value': discountValue,
        'min_order_amount': minOrderAmount,
        'max_discount': maxDiscount,
        'usage_limit': usageLimit,
        'per_user_limit': perUserLimit,
        'is_active': isActive,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'seller_id': sellerId,
        'product_ids': productIds,
        'category_ids': categoryIds,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to create coupon');
    }

    return AdminCouponModel.fromJson(response.body);
  }

  // ============================================================
  // GET ALL COUPONS
  // GET /admin/coupons/
  // ============================================================

  Future<List<AdminCouponModel>> getAllCoupons({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/coupons/',
      queryParameters: {'skip': skip, 'limit': limit},
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch coupons');
    }

    final List<dynamic> data = response.body as List<dynamic>;

    return data
        .map((json) => AdminCouponModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ============================================================
  // GET SINGLE COUPON
  // GET /admin/coupons/{coupon_id}
  // ============================================================

  Future<AdminCouponModel> getCouponById(String couponId) async {
    final response = await _apiClient.get('/admin/coupons/$couponId');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch coupon');
    }

    return AdminCouponModel.fromJson(response.body);
  }

  // ============================================================
  // UPDATE COUPON
  // PUT /admin/coupons/{coupon_id}
  // ============================================================

  Future<AdminCouponModel> updateCoupon({
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
    final Map<String, dynamic> data = {};

    if (code != null) {
      data['code'] = code;
    }

    if (description != null) {
      data['description'] = description;
    }

    if (discountType != null) {
      data['discount_type'] = discountType;
    }

    if (discountValue != null) {
      data['discount_value'] = discountValue;
    }

    if (minOrderAmount != null) {
      data['min_order_amount'] = minOrderAmount;
    }

    if (maxDiscount != null) {
      data['max_discount'] = maxDiscount;
    }

    if (usageLimit != null) {
      data['usage_limit'] = usageLimit;
    }

    if (perUserLimit != null) {
      data['per_user_limit'] = perUserLimit;
    }

    if (isActive != null) {
      data['is_active'] = isActive;
    }

    if (startDate != null) {
      data['start_date'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      data['end_date'] = endDate.toIso8601String();
    }

    if (productIds != null) {
      data['product_ids'] = productIds;
    }

    if (categoryIds != null) {
      data['category_ids'] = categoryIds;
    }

    final response = await _apiClient.put(
      '/admin/coupons/$couponId',
      data: data,
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to update coupon');
    }

    return AdminCouponModel.fromJson(response.body);
  }

  // ============================================================
  // DELETE COUPON
  // DELETE /admin/coupons/{coupon_id}
  // ============================================================

  Future<void> deleteCoupon(String couponId) async {
    final response = await _apiClient.delete('/admin/coupons/$couponId');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete coupon');
    }
  }
}
