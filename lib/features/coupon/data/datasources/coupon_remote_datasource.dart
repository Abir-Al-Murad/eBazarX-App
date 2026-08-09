import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/coupon/data/models/coupon_model.dart';

class CouponRemoteDatasource {
  final ApiClient _apiClient;
  CouponRemoteDatasource(this._apiClient);

  Future<CouponModel> validateCoupon(String couponCode, double subTotal,String userId) async {
    final response = await _apiClient.post(
      '/coupons/validate',
      data: {
        "code": couponCode,
        "subtotal": subTotal,
        "user_id": userId
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to validate coupon');
    }

    return CouponModel.fromJson(response.body);
  }
}