import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/core/failures/failure.dart';

enum SellerListStatus {
  initial,
  loading,
  success,
  failure,
}

class SellerListState {
  final SellerListStatus status;
  final List<SellerEntity> sellers;
  final Failure? failure;

  const SellerListState({
    this.status = SellerListStatus.initial,
    this.sellers = const [],
    this.failure,
  });

  bool get isLoading => status == SellerListStatus.loading;

  bool get isSuccess => status == SellerListStatus.success;

  bool get isFailure => status == SellerListStatus.failure;

  SellerListState copyWith({
    SellerListStatus? status,
    List<SellerEntity>? sellers,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SellerListState(
      status: status ?? this.status,
      sellers: sellers ?? this.sellers,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}