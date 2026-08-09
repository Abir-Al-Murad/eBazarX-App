import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Product> call({
    required String productId,
    required Map<String, dynamic> data,
  }) {
    return _repository.updateProduct(
      productId: productId,
      data: data,
    );
  }
}