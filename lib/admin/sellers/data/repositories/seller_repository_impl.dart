import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';
import '../datasources/seller_remote_data_source.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;

  const SellerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SellerEntity>> getAllSellers({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.getAllSellers(
      status: status,
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<SellerEntity>> getPendingSellers({
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.getPendingSellers(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SellerEntity> updateSellerStatus({
    required String sellerId,
    required String status,
    String? adminNotes,
  }) async {
    final result = await remoteDataSource.updateSellerStatus(
      sellerId: sellerId,
      status: status,
      adminNotes: adminNotes,
    );

    return result.toEntity();
  }
}