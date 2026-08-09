import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/presentation/states/flash_sale_list_state.dart';

import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_flash_sales_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashSaleListNotifier extends StateNotifier<FlashSaleListState> {
  final FetchFlashSalesUseCase _fetchFlashSalesUseCase;

  FlashSaleListNotifier(this._fetchFlashSalesUseCase)
      : super(const FlashSaleListState());

  Future<void> fetchFlashSales({
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    try {
      final flashSales = await _fetchFlashSalesUseCase();

      state = state.copyWith(
        isLoading: false,
        flashSales: flashSales,
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

  Future<void> refresh() async {
    await fetchFlashSales(refresh: true);
  }
}