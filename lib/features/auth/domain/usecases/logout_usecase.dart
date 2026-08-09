import 'package:ebazarx/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  LogoutUseCase(this._authRepository);
  Future<void> call({required String refreshToken}) async {
    await _authRepository.logout(refreshToken: refreshToken);
  }
}