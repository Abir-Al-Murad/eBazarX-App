

import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class UpdateFlashSaleUseCase {
  final FlashSaleRepository repository;

  const UpdateFlashSaleUseCase(this.repository);

  Future<FlashSale> call({
    required String flashSaleId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<Map<String, dynamic>>? products,
  }) async {
    return repository.updateFlashSale(
      flashSaleId: flashSaleId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      products: products,
    );
  }
}