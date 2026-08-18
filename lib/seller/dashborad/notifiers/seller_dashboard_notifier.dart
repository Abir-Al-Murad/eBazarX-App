import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_seller_dashboard_usecase.dart';
import 'package:ebazarx/seller/dashborad/states/seller_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerDashboardNotifier extends StateNotifier<SellerDashboardState> {
  final GetSellerDashboardUseCase _getSellerDashboardUseCase;

  SellerDashboardNotifier(this._getSellerDashboardUseCase)
      : super(const SellerDashboardState());

  Future<void> loadSellerDashboard() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final dashboard = await _getSellerDashboardUseCase();

      state = state.copyWith(
        isLoading: false,
        dashboardEntity: dashboard,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }
}