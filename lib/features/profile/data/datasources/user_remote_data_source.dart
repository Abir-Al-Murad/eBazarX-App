import '../models/user_profile_model.dart';
import '../../../../core/network/api_client.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<UserProfileModel> getMyProfile() async {
    final response = await _apiClient.get('/users/me');

    if (response.isSuccess) {
      return UserProfileModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to load profile');
  }
}