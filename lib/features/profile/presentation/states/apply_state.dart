import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/profile/domain/entities/seller_application_entity.dart';

class ApplyState {
  final bool isApplying;
  final SellerApplicationEntity? application;
  final Failure? failure;

  ApplyState({
    this.isApplying = false,
    this.application,
    this.failure,
  });

  ApplyState copyWith({
    bool? isApplying,
    SellerApplicationEntity? application,
    Failure? failure,
    bool clearError = false
  }){
    return ApplyState(
      isApplying: isApplying ?? this.isApplying,
      application: application ?? this.application,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}