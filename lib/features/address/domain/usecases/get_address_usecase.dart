

import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository _repository;

  const GetAddressesUseCase(this._repository);

  Future<List<AddressEntity>> call() {
    return _repository.getAddresses();
  }
}