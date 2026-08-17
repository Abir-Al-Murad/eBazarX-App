
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ebazarx/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ebazarx/features/auth/domain/usecases/login_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/register_fcm_token_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/registration_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/request_registration_otp_usecase.dart';
import 'package:ebazarx/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:ebazarx/features/auth/presentation/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authRemoteDataSourceProvider = Provider((ref)=>AuthRemoteDataSource(ref.read(apiClientProvider)));
final authRepositoryProvider = Provider((ref)=>AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)));
final loginUseCaseProvider = Provider((ref)=>LoginUseCase(ref.read(authRepositoryProvider)));
final registrationUseCaseProvider = Provider((ref)=>RegistrationUseCase(ref.read(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref)=>LogoutUseCase(ref.read(authRepositoryProvider)));
final requestRegistrationOtpUseCaseProvider = Provider((ref)=>RequestRegistrationOtpUseCase(ref.read(authRepositoryProvider)));
final registerFcmTokenUseCaseProvider = Provider((ref)=>RegisterFcmTokenUseCase(ref.read(authRepositoryProvider)));
final authNotifierProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref){
  final loginUseCase = ref.read(loginUseCaseProvider);
  final registrationUseCase = ref.read(registrationUseCaseProvider);
  final logoutUseCase = ref.read(logoutUseCaseProvider);
  final requestRegistrationOtpUseCase = ref.read(requestRegistrationOtpUseCaseProvider);
  return AuthNotifier(loginUseCase,registrationUseCase,logoutUseCase,requestRegistrationOtpUseCase);
});