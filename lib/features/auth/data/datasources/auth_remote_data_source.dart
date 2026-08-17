import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:ebazarx/core/network/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String otp,
    String? profileImage,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        "otp": otp,
        if (profileImage != null) 'profile_image': profileImage,
      },
    );

    if (response.isSuccess) {
      return response.body;
    } else {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to register');
    }
  }

  Future<Map<String, dynamic>> request_registration_otp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  }) async {
    final response = await _apiClient.post(
      '/auth/request-registration-otp',
      data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        if (profileImage != null) 'profile_image': profileImage,
      },
    );

    if (response.isSuccess) {
      return response.body;
    } else {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to send registration OTP');
    }
  }

  Future<void> registerFCMToken() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    try {
      final fcm = FirebaseMessaging.instance;
      final deviceInfo = DeviceInfoPlugin();

      final token = await fcm.getToken();

      if (token == null) return;

      String? deviceName;

      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = info.model;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceName = info.name;
      }

      await _apiClient.post(
        '/notifications/devices',
        data: {
          'token': token,
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'device_name': deviceName,
        },
      );
    } catch (e) {
      print('FCM registration failed: $e');
    }
  }

  Future<void> logout({required String refreshToken}) async {
    final response = await _apiClient.post('/auth/logout',data: {'refresh_token': refreshToken});
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to logout');
    }
  }
}