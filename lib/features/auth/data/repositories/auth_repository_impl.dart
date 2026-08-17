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
  Future<Map<String, dynamic>> register({required String fullName, required String email, required String phone, required String password, String? profileImage,required String otp}) async {
    return _authRemoteDataSource.register(profileImage: profileImage, fullName: fullName, email: email, phone: phone, password: password,otp: otp);
  }
  @override
  Future<Map<String, dynamic>> request_registration_otp({required String fullName, required String email, required String phone, required String password, String? profileImage}) async {
    return _authRemoteDataSource.request_registration_otp(profileImage: profileImage, fullName: fullName, email: email, phone: phone, password: password);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    return _authRemoteDataSource.logout(refreshToken: refreshToken);
  }

  @override
  Future<void> registerFCMToken() async {
    return _authRemoteDataSource.registerFCMToken();
  }
}