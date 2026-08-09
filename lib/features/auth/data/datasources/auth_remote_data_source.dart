import 'package:dio/dio.dart';
import 'package:ebazarx/core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  AuthRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> login({required String username, required String password}) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType
      )
    );

    if (response.isSuccess) {
      return response.body;
    } else {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to login');
    }
  }

  Future<Map<String, dynamic>> register({required String fullName, required String email,required String phone, required String password}) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    if (response.isSuccess) {
      return response.body;
    } else {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to register');
    }
  }

  Future<void> logout({required String refreshToken}) async {
    final response = await _apiClient.post('/auth/logout',data: {'refresh_token': refreshToken});
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to logout');
    }
  }
}