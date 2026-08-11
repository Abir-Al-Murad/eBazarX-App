

import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class FetchFlashSaleByIdUseCase {
  final FlashSaleRepository repository;

  const FetchFlashSaleByIdUseCase(this.repository);

  Future<FlashSale> call({
    required String flashSaleId,
  }) async {
    return repository.fetchFlashSaleById(
      flashSaleId: flashSaleId,
    );
  }
}