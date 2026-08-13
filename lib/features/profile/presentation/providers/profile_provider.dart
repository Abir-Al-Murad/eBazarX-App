import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/profile/data/datasources/user_remote_data_source.dart';
import 'package:ebazarx/features/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:ebazarx/features/profile/domain/usecases/apply_for_seller_application_usecase.dart';
import 'package:ebazarx/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ebazarx/features/profile/presentation/notifiers/apply_notifier.dart';
import 'package:ebazarx/features/profile/presentation/notifiers/profile_notifier.dart';
import 'package:ebazarx/features/profile/presentation/states/apply_state.dart';
import 'package:ebazarx/features/profile/presentation/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userRemoteDataSourceProvider = Provider((ref) => UserRemoteDataSource(ref.read(apiClientProvider)));
final userRepositoryProvider = Provider((ref)=>UserRepositoryImpl(ref.read(userRemoteDataSourceProvider)));
final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCase>((ref) => GetMyProfileUseCase(ref.read(userRepositoryProvider)));
final applyForSellerUseCaseProvider = Provider<ApplyForSellerUseCase>((ref) => ApplyForSellerUseCase(ref.read(userRepositoryProvider)));


final profileNotifierProvider = StateNotifierProvider<ProfileNotifier,ProfileState>((ref)=> ProfileNotifier(ref.read(getMyProfileUseCaseProvider)));
final applyNotifierProvider = StateNotifierProvider<ApplyNotifier, ApplyState>((ref) {
  final useCase = ref.watch(applyForSellerUseCaseProvider);
  return ApplyNotifier(useCase);
});