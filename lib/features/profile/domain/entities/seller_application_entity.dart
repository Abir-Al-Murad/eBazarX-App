import 'package:equatable/equatable.dart';

class SellerApplicationEntity extends Equatable {
  final String shopName;
  final String shopSlug;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String district;
  final String country;
  final String? tradeLicense;
  final String? nid;
  final String? tin;

  const SellerApplicationEntity({
    required this.shopName,
    required this.shopSlug,
    this.description,
    this.logo,
    this.coverImage,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.district,
    this.country = 'Bangladesh',
    this.tradeLicense,
    this.nid,
    this.tin,
  });

  @override
  List<Object?> get props => [
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
  ];
}