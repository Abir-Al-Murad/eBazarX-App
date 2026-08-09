import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Map<String, dynamic>> login({required String username, required String password}) async {
    return _authRemoteDataSource.login(username: username, password: password);
  }

  @override
  Future<Map<String, dynamic>> register({required String fullName, required String email, required String phone, required String password}) async {
    return _authRemoteDataSource.register(fullName: fullName, email: email, phone: phone, password: password);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    return _authRemoteDataSource.logout(refreshToken: refreshToken);
  }
}