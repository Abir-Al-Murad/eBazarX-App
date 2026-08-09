// import 'package:equatable/equatable.dart';
//
// enum UserRole {
//   admin,
//   seller,
//   customer,
// }
//
// class ShopProfile extends Equatable {
//   final String id;
//   final String name;
//   final String slug;
//   final String? logo;
//   final String? banner;
//   final String? description;
//   final double rating;
//   final int totalProducts;
//   final int totalFollowers;
//   final String verificationStatus;
//   final bool isActive;
//
//   const ShopProfile({
//     required this.id,
//     required this.name,
//     required this.slug,
//     this.logo,
//     this.banner,
//     this.description,
//     this.rating = 0.0,
//     this.totalProducts = 0,
//     this.totalFollowers = 0,
//     this.verificationStatus = 'pending',
//     this.isActive = true,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     slug,
//     logo,
//     banner,
//     description,
//     rating,
//     totalProducts,
//     totalFollowers,
//     verificationStatus,
//     isActive,
//   ];
// }
//
// class AdminProfile extends Equatable {
//   final List<String> permissions;
//   final DateTime? lastLogin;
//   final bool superAdmin;
//
//   const AdminProfile({
//     this.permissions = const [],
//     this.lastLogin,
//     this.superAdmin = false,
//   });
//
//   @override
//   List<Object?> get props => [permissions, lastLogin, superAdmin];
// }
//
// class UserEntity extends Equatable {
//   final String id;
//   final String fullName;
//   final String email;
//   final String phone;
//   final String? profileImage;
//   final UserRole role;
//   final bool isVerified;
//   final bool isActive;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final ShopProfile? shop;
//   final AdminProfile? admin;
//
//   const UserEntity({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.phone,
//     this.profileImage,
//     required this.role,
//     this.isVerified = false,
//     this.isActive = true,
//     required this.createdAt,
//     required this.updatedAt,
//     this.shop,
//     this.admin,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     fullName,
//     email,
//     phone,
//     profileImage,
//     role,
//     isVerified,
//     isActive,
//     createdAt,
//     updatedAt,
//     shop,
//     admin,
//   ];
//
//   bool get isSeller => role == UserRole.seller;
//   bool get isAdmin => role == UserRole.admin;
//   bool get isCustomer => role == UserRole.customer;
// }