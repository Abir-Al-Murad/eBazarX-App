import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository _repository;

  const DeleteAddressUseCase(this._repository);

  Future<void> call(String addressId) {
    return _repository.deleteAddress(addressId);
  }
}