import '../../domain/entities/flash_sale_entity.dart';
import '../../domain/repositories/flash_sale_repository.dart';
import '../datasources/flash_sale_remote_data_source.dart';

class FlashSaleRepositoryImpl implements FlashSaleRepository {
  final FlashSaleRemoteDataSource remoteDataSource;

  const FlashSaleRepositoryImpl(this.remoteDataSource);

  // ============================================================
  // GET ALL
  // ============================================================

  @override
  Future<List<FlashSale>> fetchFlashSales({
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.fetchFlashSales(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<FlashSale>> fetchAdminFlashSales({
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.fetchAdminFlashSales(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  // ============================================================
  // GET SINGLE
  // ============================================================

  @override
  Future<FlashSale> fetchFlashSaleById({
    required String flashSaleId,
  }) async {
    final result = await remoteDataSource.fetchFlashSaleById(
      flashSaleId,
    );

    return result.toEntity();
  }

  // ============================================================
  // CREATE
  // ============================================================

  @override
  Future<FlashSale> createFlashSale({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
    List<Map<String, dynamic>> products = const [],
  }) async {
    final result = await remoteDataSource.createFlashSale(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      products: products,
    );

    return result.toEntity();
  }

  // ============================================================
  // UPDATE
  // ============================================================

  @override
  Future<FlashSale> updateFlashSale({
    required String flashSaleId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<Map<String, dynamic>>? products,
  }) async {
    final result = await remoteDataSource.updateFlashSale(
      flashSaleId: flashSaleId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      products: products,
    );

    return result.toEntity();
  }

  // ============================================================
  // DELETE
  // ============================================================

  @override
  Future<void> deleteFlashSale({
    required String flashSaleId,
  }) async {
    await remoteDataSource.deleteFlashSale(
      flashSaleId,
    );
  }
}