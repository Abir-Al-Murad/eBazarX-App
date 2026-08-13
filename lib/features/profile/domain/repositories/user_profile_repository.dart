import 'package:ebazarx/features/profile/domain/entities/seller_application_entity.dart';

import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfile> getMyProfile();
  Future<SellerApplicationEntity> applyForSeller({
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
  });
}