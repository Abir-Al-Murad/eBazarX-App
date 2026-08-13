import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/auth/domain/usecases/request_registration_otp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/registration_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/login_usecase.dart';
import 'package:ebazarx/features/auth/domain/usecases/logout_usecase.dart';
import '../states/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegistrationUseCase _registrationUseCase;
  final LogoutUseCase _logoutUseCase;
  final RequestRegistrationOtpUseCase _requestRegistrationOtpUseCase;
  AuthNotifier(this._loginUseCase, this._registrationUseCase, this._logoutUseCase, this._requestRegistrationOtpUseCase) : super(const AuthState());

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLogging: true, failure: null);
    try {
      final data = await _loginUseCase.call(username: username, password: password);
      await AuthStorage.instance.saveAccessToken(data['access_token']);
      await AuthStorage.instance.saveRefreshToken(data['refresh_token']);
      state = state.copyWith(isLogging: false, failure: null);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLogging: false, failure: e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLogging: false,
        failure: const UnknownFailure('Something went wrong'),
      );
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String otp,
    String? profileImage,
  }) async {
    state = state.copyWith(isRequestingRegistrationOtp: true, failure: null);
    try {
      final result = await _registrationUseCase.call(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        otp: otp,
        profileImage: profileImage,
      );
      state = state.copyWith(isRequestingRegistrationOtp: false, failure: null);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isRequestingRegistrationOtp: false, failure: e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isRequestingRegistrationOtp: false,
        failure: const UnknownFailure('Something went wrong'),
      );
      return false;
    }
  }


  Future<bool> request_registration_otp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  })async{
    state = state.copyWith(isRegistering: true, failure: null, minute: 0);
    try {
      final result = await _requestRegistrationOtpUseCase.call(
        fullName: fullName,
        email: email,
        phone: phone,
          password: password,
        profileImage: profileImage,
      );
      state = state.copyWith(isRegistering: false, failure: null,minute:result['expires_in']);
      return true;
      } on Failure catch (e) {
      state = state.copyWith(isRegistering: false, failure: e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isRegistering: false,
        failure: const UnknownFailure('Something went wrong'),
      );
      return false;
    }
  }

  Future<void> logout({required String refreshToken}) async {
    state = state.copyWith(failure: null,isLoggingOut: true);
    try {
      await _logoutUseCase.call(refreshToken: refreshToken);
      state = state.copyWith(isLoggingOut: false, failure: null);
    } on Failure catch (e) {
      state = state.copyWith(isLoggingOut: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoggingOut: false,
        failure: const UnknownFailure('Something went wrong'));
    }
    await AuthStorage.instance.clearTokens();

  }

  void clearAuth(){
    state = const AuthState();
  }
}
