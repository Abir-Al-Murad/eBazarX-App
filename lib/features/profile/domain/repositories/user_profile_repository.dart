import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfile> getMyProfile();
}