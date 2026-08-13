import 'package:ebazarx/features/profile/data/models/seller_application_model.dart';

import '../models/user_profile_model.dart';
import '../../../../core/network/api_client.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<UserProfileModel> getMyProfile() async {
    final response = await _apiClient.get('/users/me');

    if (response.isSuccess) {
      return UserProfileModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to load profile');
  }

  Future<SellerApplicationModel> applyForSeller({
    required String shopName,
    required String shopSlug,
    String? description,
    String? logo,
    String? coverImage,
    required String phone,
    required String email,
    required String address,
    required String city,
    required String district,
    String country = 'Bangladesh',
    String? tradeLicense,
    String? nid,
    String? tin,
  }) async {
    final response = await _apiClient.post(
      '/sellers/apply/',
      data: {
        'shop_name': shopName,
        'shop_slug': shopSlug,
        'description': description,
        'logo': logo,
        'cover_image': coverImage,
        'phone': phone,
        'email': email,
        'address': address,
        'city': city,
        'district': district,
        'country': country,
        'trade_license': tradeLicense,
        'nid': nid,
        'tin': tin,
      },
    );

    if (response.isSuccess) {
      return SellerApplicationModel.fromJson(
        response.body as Map<String, dynamic>,
      );
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to apply for seller',
        );
  }

}