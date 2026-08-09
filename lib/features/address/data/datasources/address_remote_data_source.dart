import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/address/data/models/address_model.dart';

class AddressRemoteDataSource {
  final ApiClient _apiClient;

  const AddressRemoteDataSource(this._apiClient);

  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiClient.get('/customer/addresses/');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch addresses');
    }

    return (response.body as List)
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  Future<AddressModel> createAddress({
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
    final response = await _apiClient.post(
      '/customer/addresses/',
      data: {
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
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to create address');
    }

    return AddressModel.fromJson(response.body);
  }

  Future<AddressModel> updateAddress({
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
    final response = await _apiClient.put(
      '/customer/addresses/$addressId',
      data: {
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
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to update address');
    }

    return AddressModel.fromJson(response.body);
  }

  Future<void> deleteAddress(String addressId) async {
    final response = await _apiClient.delete(
      '/customer/addresses/$addressId',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete address');
    }
  }

  Future<AddressModel> setDefaultAddress(String addressId) async {
    final response = await _apiClient.put(
      '/customer/addresses/$addressId/default',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to set default address');
    }

    return AddressModel.fromJson(response.body);
  }
}