import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class FetchProductsUseCase {
  final ProductRepository _repository;

  FetchProductsUseCase(this._repository);

  Future<List<Product>> call({
    int skip = 0,
    int limit = 20,
    String? categoryId,
    String? search,
  }) {
    return _repository.fetchProducts(
      skip: skip,
      limit: limit,
      categoryId: categoryId,
      search: search,
    );
  }
}