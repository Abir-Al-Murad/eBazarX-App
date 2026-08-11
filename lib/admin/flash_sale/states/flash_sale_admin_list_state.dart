import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';

enum FlashSaleAdminListStatus {
  initial,
  loading,
  success,
  failure,
}

class FlashSaleAdminListState {
  final FlashSaleAdminListStatus status;
  final List<FlashSale> flashSales;
  final Failure? failure;

  const FlashSaleAdminListState({
    this.status = FlashSaleAdminListStatus.initial,
    this.flashSales = const [],
    this.failure,
  });

  FlashSaleAdminListState copyWith({
    FlashSaleAdminListStatus? status,
    List<FlashSale>? flashSales,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FlashSaleAdminListState(
      status: status ?? this.status,
      flashSales: flashSales ?? this.flashSales,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}