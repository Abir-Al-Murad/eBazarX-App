// models/profile_models.dart

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

  // Factory for JSON deserialization
  factory ShopProfile.fromJson(Map<String, dynamic> json) {
    return ShopProfile(
      id: json['id'],
      name: json['name'] ?? json['shop_name'],
      slug: json['slug'] ?? json['shop_slug'],
      logo: json['logo'],
      banner: json['banner'] ?? json['cover_image'],
      description: json['description'] ?? json['shop_description'],
      rating: (json['rating'] ?? json['average_rating'] ?? 0.0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      totalFollowers: json['total_followers'] ?? 0,
      verificationStatus: json['verification_status'] ?? 'pending',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'logo': logo,
    'banner': banner,
    'description': description,
    'rating': rating,
    'total_products': totalProducts,
    'total_followers': totalFollowers,
    'verification_status': verificationStatus,
    'is_active': isActive,
  };
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

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      permissions: List<String>.from(json['permissions'] ?? []),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      superAdmin: json['super_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'permissions': permissions,
    'last_login': lastLogin?.toIso8601String(),
    'super_admin': superAdmin,
  };
}

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage; // ✅ added (already present)

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

  // Factory for JSON deserialization (matches AuthenticatedUserProfileResponse)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      role: json['role'] ?? 'customer',
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      shop: json['shop'] != null ? ShopProfile.fromJson(json['shop']) : null,
      admin: json['admin'] != null ? AdminProfile.fromJson(json['admin']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'profile_image': profileImage,
    'role': role,
    'is_verified': isVerified,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'shop': shop?.toJson(),
    'admin': admin?.toJson(),
  };
}