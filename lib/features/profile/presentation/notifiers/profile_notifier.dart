import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ebazarx/features/profile/presentation/states/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetMyProfileUseCase _getMyProfileUseCase;

  ProfileNotifier(this._getMyProfileUseCase)
      : super(const ProfileState());

  Future<void> fetchProfile() async {
    if (state.isLoading) return;
    final token = await AuthStorage.instance.getAccessToken();
    if(token == null) return;
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    try {
      final profile = await _getMyProfileUseCase();

      state = state.copyWith(
        isLoading: false,
        profile: profile,
      );
    } on Failure catch (e) {
      state = ProfileState(
        isLoading: false,
        profile:null,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  void clearProfile() {
    state = const ProfileState();
  }
}