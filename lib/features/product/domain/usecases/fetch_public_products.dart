import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class FetchPublicProductsUseCase {
  final ProductRepository _productRepository;

  FetchPublicProductsUseCase(this._productRepository);

  Future<List<Product>> call({
    int skip = 0,
    int limit = 20,
    String? categoryId,
    String? search,
  }) {
    return _productRepository.fetchProducts(
        skip: skip,
        limit: limit,
        categoryId: categoryId,
        search: search
    );
  }
}