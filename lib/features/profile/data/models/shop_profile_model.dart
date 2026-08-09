import 'package:ebazarx/features/profile/domain/entities/user_entity.dart';
import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';

class ShopProfileModel {
  final String id;
  final String shopName;
  final String shopSlug;
  final String? logo;
  final String? coverImage;
  final String? description;
  final double averageRating;
  final int totalProducts;
  final int totalFollowers;
  final String verificationStatus;
  final bool isActive;

  const ShopProfileModel({
    required this.id,
    required this.shopName,
    required this.shopSlug,
    this.logo,
    this.coverImage,
    this.description,
    required this.averageRating,
    required this.totalProducts,
    required this.totalFollowers,
    required this.verificationStatus,
    required this.isActive,
  });

  factory ShopProfileModel.fromJson(Map<String, dynamic> json) {
    return ShopProfileModel(
      id: json["id"],
      shopName: json["shop_name"],
      shopSlug: json["shop_slug"],
      logo: json["logo"],
      coverImage: json["cover_image"],
      description: json["shop_description"],
      averageRating: (json["average_rating"] ?? 0).toDouble(),
      totalProducts: json["total_products"] ?? 0,
      totalFollowers: json["total_followers"] ?? 0,
      verificationStatus: json["verification_status"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_name": shopName,
    "shop_slug": shopSlug,
    "logo": logo,
    "cover_image": coverImage,
    "shop_description": description,
    "average_rating": averageRating,
    "total_products": totalProducts,
    "total_followers": totalFollowers,
    "verification_status": verificationStatus,
    "is_active": isActive,
  };

  ShopProfile toEntity() {
    return ShopProfile(
      id: id,
      name: shopName,
      slug: shopSlug,
      logo: logo,
      banner: coverImage,
      description: description,
      rating: averageRating,
      totalProducts: totalProducts,
      totalFollowers: totalFollowers,
      verificationStatus: verificationStatus,
      isActive: isActive,
    );
  }
}