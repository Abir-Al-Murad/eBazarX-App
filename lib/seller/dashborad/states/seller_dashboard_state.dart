import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';

class SellerDashboardState {
  final bool isLoading;
  final DashboardEntity? dashboardEntity;
  final Failure? failure;

  const SellerDashboardState({
    this.isLoading = false,
    this.dashboardEntity,
    this.failure,
  });

  SellerDashboardState copyWith({
    bool? isLoading,
    DashboardEntity? dashboardEntity,
    Failure? failure,
    bool clearError = false,
  }) {
    return SellerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      dashboardEntity: dashboardEntity ?? this.dashboardEntity,
      failure: clearError
          ? null
          : (failure ?? this.failure),
    );
  }
}