import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class FetchFlashSalesUseCase {
  final FlashSaleRepository _flashSaleRepository;

  FetchFlashSalesUseCase(this._flashSaleRepository);

  Future<List<FlashSale>> call() async {
    return _flashSaleRepository.fetchFlashSales();
  }
}