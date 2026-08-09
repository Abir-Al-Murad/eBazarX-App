import 'package:ebazarx/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/set_as_default_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/update_address_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/create_address_usecase.dart';
import 'package:ebazarx/features/address/presentation/states/address_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddressNotifier extends StateNotifier<AddressState> {
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  AddressNotifier(
      this._createAddressUseCase,
      this._updateAddressUseCase,
      this._deleteAddressUseCase,
      this._setDefaultAddressUseCase,
      ) : super(const AddressState());

  Future<void> createAddress({
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
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isSuccess: false,
    );

    try {
      await _createAddressUseCase(
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

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAddress({
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
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isSuccess: false,
    );

    try {
      await _updateAddressUseCase(
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

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAddress(String addressId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _deleteAddressUseCase(addressId);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _setDefaultAddressUseCase(addressId);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const AddressState();
  }
}