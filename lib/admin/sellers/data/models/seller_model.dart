import '../../domain/entities/seller_entity.dart';

class SellerModel {
  final String id;
  final String userId;

  final String? userFullName;
  final String? userEmail;
  final String? userPhone;

  final String shopName;
  final String shopSlug;
  final String? description;

  final String? logo;
  final String? coverImage;

  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? district;
  final String? country;

  final String? tradeLicense;
  final String? nid;
  final String? tin;

  final double commissionRate;
  final String status;

  final double averageRating;
  final int totalProducts;
  final int totalOrders;

  final DateTime joinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SellerModel({
    required this.id,
    required this.userId,
    this.userFullName,
    this.userEmail,
    this.userPhone,
    required this.shopName,
    required this.shopSlug,
    this.description,
    this.logo,
    this.coverImage,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.district,
    this.country,
    this.tradeLicense,
    this.nid,
    this.tin,
    required this.commissionRate,
    required this.status,
    required this.averageRating,
    required this.totalProducts,
    required this.totalOrders,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',

      userFullName: json['user_full_name']?.toString(),
      userEmail: json['user_email']?.toString(),
      userPhone: json['user_phone']?.toString(),

      shopName: json['shop_name']?.toString() ?? '',
      shopSlug: json['shop_slug']?.toString() ?? '',
      description: json['description']?.toString(),

      logo: json['logo']?.toString(),
      coverImage: json['cover_image']?.toString(),

      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      country: json['country']?.toString(),

      tradeLicense: json['trade_license']?.toString(),
      nid: json['nid']?.toString(),
      tin: json['tin']?.toString(),

      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',

      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,

      joinedAt: DateTime.parse(json['joined_at'].toString()),
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,

      'user_full_name': userFullName,
      'user_email': userEmail,
      'user_phone': userPhone,

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

      'commission_rate': commissionRate,
      'status': status,

      'average_rating': averageRating,
      'total_products': totalProducts,
      'total_orders': totalOrders,

      'joined_at': joinedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SellerEntity toEntity() {
    return SellerEntity(
      id: id,
      userId: userId,

      userFullName: userFullName,
      userEmail: userEmail,
      userPhone: userPhone,

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

      commissionRate: commissionRate,
      status: status,

      averageRating: averageRating,
      totalProducts: totalProducts,
      totalOrders: totalOrders,

      joinedAt: joinedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SellerModel.fromEntity(SellerEntity entity) {
    return SellerModel(
      id: entity.id,
      userId: entity.userId,

      userFullName: entity.userFullName,
      userEmail: entity.userEmail,
      userPhone: entity.userPhone,

      shopName: entity.shopName,
      shopSlug: entity.shopSlug,
      description: entity.description,

      logo: entity.logo,
      coverImage: entity.coverImage,

      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      city: entity.city,
      district: entity.district,
      country: entity.country,

      tradeLicense: entity.tradeLicense,
      nid: entity.nid,
      tin: entity.tin,

      commissionRate: entity.commissionRate,
      status: entity.status,

      averageRating: entity.averageRating,
      totalProducts: entity.totalProducts,
      totalOrders: entity.totalOrders,

      joinedAt: entity.joinedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}