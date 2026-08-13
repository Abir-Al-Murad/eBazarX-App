import 'package:ebazarx/features/auth/domain/repositories/auth_repository.dart';

class RegistrationUseCase {
  AuthRepository _repository;

  RegistrationUseCase(this._repository);

  Future<Map<String, dynamic>> call(
      {String? profileImage, required String fullName, required String email, required String password, required String phone, required String otp}) async {
    {
      return await _repository.register(profileImage: profileImage,
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          otp: otp);
    }
  }
}