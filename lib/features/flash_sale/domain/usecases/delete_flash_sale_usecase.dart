
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class DeleteFlashSaleUseCase {
  final FlashSaleRepository repository;

  const DeleteFlashSaleUseCase(this.repository);

  Future<void> call({
    required String flashSaleId,
  }) async {
    return repository.deleteFlashSale(
      flashSaleId: flashSaleId,
    );
  }
}