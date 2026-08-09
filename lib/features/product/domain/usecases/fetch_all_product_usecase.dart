import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class FetchAllProductsUseCase {
  final ProductRepository _repository;

  FetchAllProductsUseCase(this._repository);

  Future<List<Product>> call({
    int skip = 0,
    int limit = 20,
    String? approvalStatus,
  }) {
    return _repository.fetchAllProducts(
      skip: skip,
      limit: limit,
      approvalStatus: approvalStatus,
    );
  }
}