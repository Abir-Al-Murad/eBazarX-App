import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/address/data/datasources/address_remote_data_source.dart';
import 'package:ebazarx/features/address/data/repositories/address_repository_impl.dart';
import 'package:ebazarx/features/address/domain/repositories/address_repository.dart';
import 'package:ebazarx/features/address/domain/usecases/create_address_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/get_address_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/set_as_default_usecase.dart';
import 'package:ebazarx/features/address/domain/usecases/update_address_usecase.dart';
import 'package:ebazarx/features/address/presentation/notifiers/address_list_notifier.dart';
import 'package:ebazarx/features/address/presentation/notifiers/address_notifier.dart';
import 'package:ebazarx/features/address/presentation/states/address_list_state.dart';
import 'package:ebazarx/features/address/presentation/states/address_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Data Source

final addressRemoteDataSourceProvider =
Provider<AddressRemoteDataSource>((ref) {
  return AddressRemoteDataSource(
    ref.read(apiClientProvider),
  );
});

/// Repository

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepositoryImpl(
    ref.read(addressRemoteDataSourceProvider),
  );
});

/// UseCases

final getAddressesUseCaseProvider = Provider<GetAddressesUseCase>((ref) {
  return GetAddressesUseCase(
    ref.read(addressRepositoryProvider),
  );
});

final createAddressUseCaseProvider = Provider<CreateAddressUseCase>((ref) {
  return CreateAddressUseCase(
    ref.read(addressRepositoryProvider),
  );
});

final updateAddressUseCaseProvider = Provider<UpdateAddressUseCase>((ref) {
  return UpdateAddressUseCase(
    ref.read(addressRepositoryProvider),
  );
});

final deleteAddressUseCaseProvider = Provider<DeleteAddressUseCase>((ref) {
  return DeleteAddressUseCase(
    ref.read(addressRepositoryProvider),
  );
});

final setDefaultAddressUseCaseProvider =
Provider<SetDefaultAddressUseCase>((ref) {
  return SetDefaultAddressUseCase(
    ref.read(addressRepositoryProvider),
  );
});

/// Notifiers

final addressListProvider =
StateNotifierProvider<AddressListNotifier, AddressListState>((ref) {
  return AddressListNotifier(
    ref.read(getAddressesUseCaseProvider),
  );
});

final addressProvider =
StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(
    ref.read(createAddressUseCaseProvider),
    ref.read(updateAddressUseCaseProvider),
    ref.read(deleteAddressUseCaseProvider),
    ref.read(setDefaultAddressUseCaseProvider),
  );
});