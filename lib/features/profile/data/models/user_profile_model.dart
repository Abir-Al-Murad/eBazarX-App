import 'package:ebazarx/features/profile/data/models/admin_profile_model.dart';
import 'package:ebazarx/features/profile/data/models/shop_profile_model.dart';
import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;

  final String role;
  final bool isVerified;
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  final ShopProfileModel? shop;
  final AdminProfileModel? admin;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.shop,
    this.admin,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      phone: json["phone"],
      profileImage: json["profile_image"],
      role: json["role"],
      isVerified: json["is_verified"],
      isActive: json["is_active"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      shop: json["shop"] != null
          ? ShopProfileModel.fromJson(json["shop"])
          : null,
      admin: json["admin"] != null
          ? AdminProfileModel.fromJson(json["admin"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone": phone,
    "profile_image": profileImage,
    "role": role,
    "is_verified": isVerified,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "shop": shop?.toJson(),
    "admin": admin?.toJson(),
  };

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      profileImage: profileImage,
      role: role,
      isVerified: isVerified,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      shop: shop?.toEntity(),
      admin: admin?.toEntity(),
    );
  }
}