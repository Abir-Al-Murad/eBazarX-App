import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getAddresses();

  Future<AddressEntity> createAddress({
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
  });

  Future<AddressEntity> updateAddress({
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
  });

  Future<void> deleteAddress(String addressId);

  Future<AddressEntity> setDefaultAddress(String addressId);
}