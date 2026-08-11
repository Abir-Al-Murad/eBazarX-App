

import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class CreateFlashSaleUseCase {
  final FlashSaleRepository repository;

  const CreateFlashSaleUseCase(this.repository);

  Future<FlashSale> call({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
    List<Map<String, dynamic>> products = const [],
  }) async {
    return repository.createFlashSale(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      products: products,
    );
  }
}