import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:neighborly/features/login/data/models/user_model.dart';

class AuthStorage{
  AuthStorage._();
  static final AuthStorage instance = AuthStorage._();
  static String? accessToken;
  final String _accessTokenKey = 'access_token';
  final String _refreshTokenKey = 'refresh_token';
  // UserModel? user;
  // final String _userIdKey = 'user_id';

  bool get isLoggedIn => accessToken != null;

  Future<void> saveAccessToken(String token)async{
    await FlutterSecureStorage().write(key: _accessTokenKey, value: token);
    accessToken = token;
  }

  Future<void> saveRefreshToken(String refreshToken)async{
    await FlutterSecureStorage().write(key: _refreshTokenKey, value: refreshToken);
  }

  // void saveUser(UserModel user){
  //   this.user = user;
  // }

  Future<String?> getAccessToken()async{
    final token = await FlutterSecureStorage().read(key: _accessTokenKey);
    accessToken = token;
    return token;
  }

  Future<String?> getRefreshToken()async{
    return await FlutterSecureStorage().read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await FlutterSecureStorage().deleteAll();
  }
}