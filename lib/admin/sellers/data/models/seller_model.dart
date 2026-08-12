import '../../domain/entities/seller_entity.dart';

class SellerModel {
  final String id;
  final String userId;
  final String shopName;
  final String shopSlug;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userEmail;
  final String? userPhone;

  const SellerModel({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.shopSlug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.userEmail,
    this.userPhone,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      shopName: json['shop_name']?.toString() ?? '',
      shopSlug: json['shop_slug']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
      userEmail: json['user_email']?.toString(),
      userPhone: json['user_phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'shop_name': shopName,
      'shop_slug': shopSlug,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_email': userEmail,
      'user_phone': userPhone,
    };
  }

  SellerEntity toEntity() {
    return SellerEntity(
      id: id,
      userId: userId,
      shopName: shopName,
      shopSlug: shopSlug,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userEmail: userEmail,
      userPhone: userPhone,
    );
  }

  factory SellerModel.fromEntity(SellerEntity entity) {
    return SellerModel(
      id: entity.id,
      userId: entity.userId,
      shopName: entity.shopName,
      shopSlug: entity.shopSlug,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userEmail: entity.userEmail,
      userPhone: entity.userPhone,
    );
  }
}