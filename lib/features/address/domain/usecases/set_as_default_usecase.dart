import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/domain/repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  final AddressRepository _repository;

  const SetDefaultAddressUseCase(this._repository);

  Future<AddressEntity> call(String addressId) {
    return _repository.setDefaultAddress(addressId);
  }
}