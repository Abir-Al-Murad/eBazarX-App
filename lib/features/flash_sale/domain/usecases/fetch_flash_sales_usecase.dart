import '../entities/flash_sale_entity.dart';
import '../repositories/flash_sale_repository.dart';

class FetchFlashSalesUseCase {
  final FlashSaleRepository repository;

  const FetchFlashSalesUseCase(this.repository);

  Future<List<FlashSale>> call({
    int skip = 0,
    int limit = 20,
  }) async {
    return repository.fetchFlashSales(
      skip: skip,
      limit: limit,
    );
  }
}