import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class FetchPendingProductsUseCase {
  final ProductRepository _repository;

  FetchPendingProductsUseCase(this._repository);

  Future<List<Product>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return _repository.fetchPendingProducts(
      skip: skip,
      limit: limit,
    );
  }
}