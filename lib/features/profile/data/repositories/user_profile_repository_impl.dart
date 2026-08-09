import 'package:ebazarx/features/profile/data/datasources/user_remote_data_source.dart';
import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ebazarx/features/profile/domain/repositories/user_profile_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfile> getMyProfile() async {
    final model = await _remoteDataSource.getMyProfile();
    return model.toEntity();
  }
}