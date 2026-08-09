import 'package:ebazarx/features/profile/domain/entities/user_profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final Object? failure;
  final UserProfile? profile;

  const ProfileState({
    this.isLoading = false,
    this.failure,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoading,
    Object? failure,
    UserProfile? profile,
    bool clearFailure = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      profile: profile ?? this.profile,
    );
  }
}