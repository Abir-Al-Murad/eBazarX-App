
import 'package:ebazarx/features/profile/domain/entities/seller_application_entity.dart';
import 'package:ebazarx/features/profile/domain/repositories/user_profile_repository.dart';

class ApplyForSellerUseCase {
  final UserRepository _repository;

  ApplyForSellerUseCase(this._repository);

  Future<SellerApplicationEntity> call({
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
  }) {
    return _repository.applyForSeller(
      shopName: shopName,
      shopSlug: shopSlug,
      description: description,
      logo: logo,
      coverImage: coverImage,
      phone: phone,
      email: email,
      address: address,
      city: city,
      district: district,
      country: country,
      tradeLicense: tradeLicense,
      nid: nid,
      tin: tin,
    );
  }
}