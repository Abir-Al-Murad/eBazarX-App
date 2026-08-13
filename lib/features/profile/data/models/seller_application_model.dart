import 'package:ebazarx/features/profile/domain/entities/seller_application_entity.dart';

class SellerApplicationModel extends SellerApplicationEntity {
  const SellerApplicationModel({
    required super.shopName,
    required super.shopSlug,
    super.description,
    super.logo,
    super.coverImage,
    required super.phone,
    required super.email,
    required super.address,
    required super.city,
    required super.district,
    super.country,
    super.tradeLicense,
    super.nid,
    super.tin,
  });

  factory SellerApplicationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SellerApplicationModel(
      shopName: json['shop_name'] as String,
      shopSlug: json['shop_slug'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      coverImage: json['cover_image'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      country: json['country'] as String? ?? 'Bangladesh',
      tradeLicense: json['trade_license'] as String?,
      nid: json['nid'] as String?,
      tin: json['tin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  SellerApplicationEntity toEntity() {
    return SellerApplicationEntity(
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