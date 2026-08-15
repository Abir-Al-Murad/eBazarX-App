import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
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

  const SellerEntity({
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

  @override
  List<Object?> get props => [
    id,
    userId,
    userFullName,
    userEmail,
    userPhone,
    shopName,
    shopSlug,
    description,
    logo,
    coverImage,
    phone,
    email,
    address,
    city,
    district,
    country,
    tradeLicense,
    nid,
    tin,
    commissionRate,
    status,
    averageRating,
    totalProducts,
    totalOrders,
    joinedAt,
    createdAt,
    updatedAt,
  ];
}