import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String? division;
  final String? district;
  final String? upazila;
  final String? area;
  final String addressLine;
  final String? postalCode;
  final String label;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    this.division,
    this.district,
    this.upazila,
    this.area,
    required this.addressLine,
    this.postalCode,
    required this.label,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    phone,
    division,
    district,
    upazila,
    area,
    addressLine,
    postalCode,
    label,
    isDefault,
    createdAt,
    updatedAt,
  ];
}