import 'package:ebazarx/features/auth/domain/repositories/auth_repository.dart';

class RequestRegistrationOtpUseCase {
  final AuthRepository _authRepository;
  RequestRegistrationOtpUseCase(this._authRepository);

  Future<Map<String,dynamic>> call({required String fullName, required String email, required String phone, required String password, String? profileImage}) async {
    return _authRepository.request_registration_otp(profileImage: profileImage, fullName: fullName, email: email, phone: phone, password: password);
  }
}