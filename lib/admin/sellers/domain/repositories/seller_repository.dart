import '../entities/seller_entity.dart';

abstract class SellerRepository {
  Future<List<SellerEntity>> getAllSellers({
    String? status,
    int skip = 0,
    int limit = 20,
  });

  Future<List<SellerEntity>> getPendingSellers({
    int skip = 0,
    int limit = 20,
  });

  Future<SellerEntity> updateSellerStatus({
    required String sellerId,
    required String status,
    String? adminNotes,
  });
}