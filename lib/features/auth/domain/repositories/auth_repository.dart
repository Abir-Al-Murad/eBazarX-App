abstract class AuthRepository {
  Future<Map<String,dynamic>> login({required String username, required String password});
  Future<Map<String,dynamic>> register({required String fullName, required String email, required String phone, required String password, String? profileImage, required String otp});
  Future<Map<String,dynamic>> request_registration_otp({required String fullName, required String email, required String phone, required String password, String? profileImage});
  Future<void> registerFCMToken();
  Future<void> logout({required String refreshToken});
}