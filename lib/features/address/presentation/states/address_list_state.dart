

import 'package:ebazarx/features/address/domain/entities/address_entity.dart';

class AddressListState {
  final List<AddressEntity> addresses;
  final bool isLoading;
  final String? error;

  const AddressListState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressListState copyWith({
    List<AddressEntity>? addresses,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AddressListState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}