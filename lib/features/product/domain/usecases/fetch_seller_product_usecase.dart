import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class FetchSellerProductsUseCase {
  final ProductRepository _repository;

  FetchSellerProductsUseCase(this._repository);

  Future<List<Product>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return _repository.fetchSellerProducts(
      skip: skip,
      limit: limit,
    );
  }
}