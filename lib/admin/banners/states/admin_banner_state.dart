import 'package:ebazarx/core/failures/failure.dart';

class AdminBannerState {
  final bool isDeleting;
  final bool isUpdating;
  final bool isCreating;
  final Failure? failure;

  const AdminBannerState({
    this.isDeleting = false,
    this.isUpdating = false,
    this.isCreating = false,
    this.failure,
  });

  AdminBannerState copyWith({
    bool? isDeleting,
    bool? isUpdating,
    bool? isCreating,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return AdminBannerState(
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdating: isUpdating ?? this.isUpdating,
      isCreating: isCreating ?? this.isCreating,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}