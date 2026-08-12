import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final String id;
  final String userId;
  final String shopName;
  final String shopSlug;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userEmail;
  final String? userPhone;

  const SellerEntity({
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

  @override
  List<Object?> get props => [
    id,
    userId,
    shopName,
    shopSlug,
    status,
    createdAt,
    updatedAt,
    userEmail,
    userPhone,
  ];
}