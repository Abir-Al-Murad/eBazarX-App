import '../../domain/entities/flash_sale_entity.dart';
import '../../domain/repositories/flash_sale_repository.dart';
import '../datasources/flash_sale_remote_data_source.dart';

class FlashSaleRepositoryImpl implements FlashSaleRepository {
  final FlashSaleRemoteDataSource remoteDataSource;

  const FlashSaleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FlashSale>> fetchFlashSales() async {
    final result = await remoteDataSource.fetchFlashSales();

    return result.map((e) => e.toEntity()).toList();
  }
}