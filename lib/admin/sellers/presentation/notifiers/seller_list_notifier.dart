import 'package:ebazarx/admin/sellers/domain/usecases/get_all_seller_usecase.dart';
import 'package:ebazarx/admin/sellers/domain/usecases/get_pending_sellers_usecase.dart';
import 'package:ebazarx/admin/sellers/presentation/states/seller_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerListNotifier extends StateNotifier<SellerListState> {
  final GetAllSellersUseCase _getAllSellersUseCase;
  final GetPendingSellersUseCase _getPendingSellersUseCase;

  SellerListNotifier({
    required GetAllSellersUseCase getAllSellersUseCase,
    required GetPendingSellersUseCase getPendingSellersUseCase,
  })  : _getAllSellersUseCase = getAllSellersUseCase,
        _getPendingSellersUseCase = getPendingSellersUseCase,
        super(const SellerListState());

  // ============================================================
  // GET ALL SELLERS
  // ============================================================

  Future<bool> getAllSellers({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    state = state.copyWith(
      status: SellerListStatus.loading,
      clearFailure: true,
    );

    try {
      final sellers = await _getAllSellersUseCase(
        status: status,
        skip: skip,
        limit: limit,
      );

      state = state.copyWith(
        status: SellerListStatus.success,
        sellers: sellers,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerListStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerListStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // GET PENDING SELLERS
  // ============================================================

  Future<bool> getPendingSellers({
    int skip = 0,
    int limit = 20,
  }) async {
    state = state.copyWith(
      status: SellerListStatus.loading,
      clearFailure: true,
    );

    try {
      final sellers = await _getPendingSellersUseCase(
        skip: skip,
        limit: limit,
      );

      state = state.copyWith(
        status: SellerListStatus.success,
        sellers: sellers,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: SellerListStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: SellerListStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const SellerListState();
  }
}