import 'package:ebazarx/admin/flash_sale/states/flash_sale_admin_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_admin_flash_sales_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashSaleAdminListNotifier
    extends StateNotifier<FlashSaleAdminListState> {
  final FetchAdminFlashSales _fetchAdminFlashSales;

  FlashSaleAdminListNotifier(this._fetchAdminFlashSales)
      : super(const FlashSaleAdminListState());

  // ============================================================
  // FETCH ALL ADMIN FLASH SALES
  // ============================================================

  Future<void> fetchFlashSales() async {
    state = state.copyWith(
      status: FlashSaleAdminListStatus.loading,
      clearFailure: true,
    );

    try {
      final flashSales = await _fetchAdminFlashSales();

      state = state.copyWith(
        status: FlashSaleAdminListStatus.success,
        flashSales: flashSales,
        clearFailure: true,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        status: FlashSaleAdminListStatus.failure,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        status: FlashSaleAdminListStatus.failure,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await fetchFlashSales();
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const FlashSaleAdminListState();
  }
}