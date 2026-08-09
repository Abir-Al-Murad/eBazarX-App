abstract class AuthRepository {
  Future<Map<String,dynamic>> login({required String username, required String password});
  Future<Map<String,dynamic>> register({required String fullName, required String email, required String phone, required String password});
  Future<void> logout({required String refreshToken});
}