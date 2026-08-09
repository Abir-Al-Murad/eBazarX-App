import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class GetSellerProductUseCase {
  final ProductRepository _repository;

  GetSellerProductUseCase(this._repository);

  Future<Product> call(String productId) {
    return _repository.getSellerProduct(productId);
  }
}