import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Map<String, dynamic>> call({required String username, required String password}) async {
    return await authRepository.login(username: username, password: password);
  }
}