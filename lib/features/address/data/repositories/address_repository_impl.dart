import 'package:ebazarx/features/address/data/datasources/address_remote_data_source.dart';
import 'package:ebazarx/features/address/data/models/address_model.dart';
import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource _remoteDataSource;

  const AddressRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AddressEntity>> getAddresses() async {
    final addresses = await _remoteDataSource.getAddresses();

    return addresses.map((e) => e.toEntity()).toList();
  }

  @override
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
  }) async {
    final address = await _remoteDataSource.createAddress(
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

    return address.toEntity();
  }

  @override
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
  }) async {
    final address = await _remoteDataSource.updateAddress(
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

    return address.toEntity();
  }

  @override
  Future<void> deleteAddress(String addressId) {
    return _remoteDataSource.deleteAddress(addressId);
  }

  @override
  Future<AddressEntity> setDefaultAddress(String addressId) async {
    final address =
    await _remoteDataSource.setDefaultAddress(addressId);

    return address.toEntity();
  }
}