import 'package:ebazarx/features/profile/domain/entities/user_entity.dart';
import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';

class AdminProfileModel {
  final List<String> permissions;
  final DateTime? lastLogin;
  final bool superAdmin;

  const AdminProfileModel({
    required this.permissions,
    this.lastLogin,
    required this.superAdmin,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      permissions: List<String>.from(json["permissions"] ?? []),
      lastLogin: json["last_login"] != null
          ? DateTime.parse(json["last_login"])
          : null,
      superAdmin: json["super_admin"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "permissions": permissions,
    "last_login": lastLogin?.toIso8601String(),
    "super_admin": superAdmin,
  };

  AdminProfile toEntity() {
    return AdminProfile(
      permissions: permissions,
      lastLogin: lastLogin,
      superAdmin: superAdmin,
    );
  }
}