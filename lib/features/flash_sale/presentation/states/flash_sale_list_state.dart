import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';

class FlashSaleListState {
  final bool isLoading;
  final List<FlashSale> flashSales;
  final Failure? failure;

  const FlashSaleListState({
    this.isLoading = false,
    this.flashSales = const [],
    this.failure,
  });

  FlashSaleListState copyWith({
    bool? isLoading,
    List<FlashSale>? flashSales,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FlashSaleListState(
      isLoading: isLoading ?? this.isLoading,
      flashSales: flashSales ?? this.flashSales,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}