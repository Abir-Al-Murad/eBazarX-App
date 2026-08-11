import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';

enum FlashSaleCrudStatus {
  initial,
  loading,
  success,
  failure,
}

class FlashSaleCrudState {
  final FlashSaleCrudStatus status;
  final FlashSale? flashSale;
  final Failure? failure;

  const FlashSaleCrudState({
    this.status = FlashSaleCrudStatus.initial,
    this.flashSale,
    this.failure,
  });

  bool get isLoading => status == FlashSaleCrudStatus.loading;

  bool get isSuccess => status == FlashSaleCrudStatus.success;

  bool get isFailure => status == FlashSaleCrudStatus.failure;

  FlashSaleCrudState copyWith({
    FlashSaleCrudStatus? status,
    FlashSale? flashSale,
    Failure? failure,
    bool clearFlashSale = false,
    bool clearFailure = false,
  }) {
    return FlashSaleCrudState(
      status: status ?? this.status,
      flashSale: clearFlashSale ? null : flashSale ?? this.flashSale,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}