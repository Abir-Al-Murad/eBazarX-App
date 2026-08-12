import 'package:ebazarx/admin/sellers/domain/usecases/update_seller_status_usecase.dart';
import 'package:ebazarx/admin/sellers/presentation/states/seller_crud_state.dart';
import 'package:ebazarx/core/failures/failure.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerCrudNotifier extends StateNotifier<SellerCrudState> {
  final UpdateSellerStatusUseCase _updateSellerStatusUseCase;

  SellerCrudNotifier({
    required UpdateSellerStatusUseCase updateSellerStatusUseCase,
  })  : _updateSellerStatusUseCase = updateSellerStatusUseCase,
        super(const SellerCrudState());

  // ============================================================
  // UPDATE SELLER STATUS
  // ============================================================

  Future<bool> updateSellerStatus({
    required String sellerId,
    required String status,
    String? adminNotes,
  }) async {
    state = state.copyWith(
      status: SellerCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final seller = await _updateSellerStatusUseCase(
        sellerId: sellerId,
        status: status,
        adminNotes: adminNotes,
      );

      state = state.copyWith(
        status: SellerCrudStatus.success,
        seller: seller,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const SellerCrudState();
  }
}