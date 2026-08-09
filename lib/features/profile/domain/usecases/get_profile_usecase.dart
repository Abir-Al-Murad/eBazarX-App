import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ebazarx/features/profile/domain/repositories/user_profile_repository.dart';

class GetMyProfileUseCase {
  final UserRepository _repository;

  GetMyProfileUseCase(this._repository);

  Future<UserProfile> call() {
    return _repository.getMyProfile();
  }
}