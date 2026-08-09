import '../entities/flash_sale_entity.dart';

abstract class FlashSaleRepository {
  Future<List<FlashSale>> fetchFlashSales();
}