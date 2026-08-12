import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/core/failures/failure.dart';

enum SellerCrudStatus {
  initial,
  loading,
  success,
  failure,
}

class SellerCrudState {
  final SellerCrudStatus status;
  final SellerEntity? seller;
  final Failure? failure;

  const SellerCrudState({
    this.status = SellerCrudStatus.initial,
    this.seller,
    this.failure,
  });

  bool get isLoading => status == SellerCrudStatus.loading;

  bool get isSuccess => status == SellerCrudStatus.success;

  bool get isFailure => status == SellerCrudStatus.failure;

  SellerCrudState copyWith({
    SellerCrudStatus? status,
    SellerEntity? seller,
    Failure? failure,
    bool clearSeller = false,
    bool clearFailure = false,
  }) {
    return SellerCrudState(
      status: status ?? this.status,
      seller: clearSeller ? null : seller ?? this.seller,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}