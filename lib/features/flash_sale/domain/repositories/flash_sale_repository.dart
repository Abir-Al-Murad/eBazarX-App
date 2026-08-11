import '../entities/flash_sale_entity.dart';

abstract class FlashSaleRepository {
  // Get all flash sales
  Future<List<FlashSale>> fetchFlashSales({
    int skip = 0,
    int limit = 20,
  });

  Future<List<FlashSale>> fetchAdminFlashSales({
    int skip = 0,
    int limit = 20,
  });

  // Get single flash sale
  Future<FlashSale> fetchFlashSaleById({
    required String flashSaleId,
  });

  // Create flash sale
  Future<FlashSale> createFlashSale({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
    List<Map<String, dynamic>> products = const [],
  });

  // Update flash sale
  Future<FlashSale> updateFlashSale({
    required String flashSaleId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<Map<String, dynamic>>? products,
  });

  // Delete flash sale
  Future<void> deleteFlashSale({
    required String flashSaleId,
  });
}