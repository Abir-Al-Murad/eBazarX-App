

import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/domain/repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository _repository;

  const UpdateAddressUseCase(this._repository);

  Future<AddressEntity> call({
    required String addressId,
    required String fullName,
    required String phone,
    required String division,
    required String district,
    required String upazila,
    required String area,
    required String addressLine,
    required String postalCode,
    required String label,
    bool isDefault = false,
  }) {
    return _repository.updateAddress(
      addressId: addressId,
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
    );
  }
}