class ShopProfile {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final String? banner;
  final String? description;
  final double rating;
  final int totalProducts;
  final int totalFollowers;
  final String verificationStatus;
  final bool isActive;

  const ShopProfile({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.banner,
    this.description,
    required this.rating,
    required this.totalProducts,
    required this.totalFollowers,
    required this.verificationStatus,
    required this.isActive,
  });

  bool get isVerified => verificationStatus.toLowerCase() == 'verified';
}

class AdminProfile {
  final List<String> permissions;
  final DateTime? lastLogin;
  final bool superAdmin;

  const AdminProfile({
    required this.permissions,
    this.lastLogin,
    required this.superAdmin,
  });
}

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;

  /// "customer" | "seller" | "admin"
  final String role;
  final bool isVerified;
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  final ShopProfile? shop;
  final AdminProfile? admin;

  const UserProfile({
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

  bool get isSeller => role.toLowerCase() == 'seller';
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isCustomer => role.toLowerCase() == 'customer';

  /// Used by the placeholder avatar when profileImage is null.
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}