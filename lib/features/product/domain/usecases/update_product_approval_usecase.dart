import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class UpdateProductApprovalUseCase {
  final ProductRepository _repository;

  UpdateProductApprovalUseCase(this._repository);

  Future<Product> call({
    required String productId,
    required String approvalStatus,
    String? notes,
  }) {
    return _repository.updateApproval(
      productId: productId,
      approvalStatus: approvalStatus,
      notes: notes,
    );
  }
}