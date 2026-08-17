import 'package:ebazarx/features/auth/domain/repositories/auth_repository.dart';

class RegisterFcmTokenUseCase {
  final AuthRepository _authRepository;
  RegisterFcmTokenUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.registerFCMToken();
  }
}