import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class FetchAdminFlashSales {
  final FlashSaleRepository _repository;
  FetchAdminFlashSales(this._repository);

  Future<List<FlashSale>> call({
    int skip = 0,
    int limit = 20,
  }) async {
    return _repository.fetchAdminFlashSales(
      skip: skip,
      limit: limit,
    );
  }
}