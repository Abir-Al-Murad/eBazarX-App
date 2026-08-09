import 'package:ebazarx/features/address/domain/entities/address_entity.dart';

class AddressModel {
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

  const AddressModel({
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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      division: json['division'] as String?,
      district: json['district'] as String?,
      upazila: json['upazila'] as String?,
      area: json['area'] as String?,
      addressLine: json['address_line'] as String,
      postalCode: json['postal_code'] as String?,
      label: json['label'] as String,
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'division': division,
      'district': district,
      'upazila': upazila,
      'area': area,
      'address_line': addressLine,
      'postal_code': postalCode,
      'label': label,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      phone: entity.phone,
      division: entity.division,
      district: entity.district,
      upazila: entity.upazila,
      area: entity.area,
      addressLine: entity.addressLine,
      postalCode: entity.postalCode,
      label: entity.label,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      userId: userId,
      fullName: fullName,
      phone: phone,
      division: division,
      district: district,
      upazila: upazila,
      area: area,
      addressLine: addressLine,
      postalCode: postalCode,
      label: label,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}