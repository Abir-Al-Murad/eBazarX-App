import 'package:ebazarx/features/address/domain/usecases/get_address_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/address_list_state.dart';

class AddressListNotifier extends StateNotifier<AddressListState> {
  final GetAddressesUseCase _getAddressesUseCase;

  AddressListNotifier(this._getAddressesUseCase)
      : super(const AddressListState());

  Future<void> loadAddresses() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final addresses = await _getAddressesUseCase();

      state = state.copyWith(
        addresses: addresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadAddresses();
  }

  void reset(){
    state = const AddressListState();
  }
}