

import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/admin/sellers/domain/repositories/seller_repository.dart';

class GetAllSellersUseCase {
  final SellerRepository repository;

  const GetAllSellersUseCase(this.repository);

  Future<List<SellerEntity>> call({
    String? status,
    int skip = 0,
    int limit = 20,
  }) {
    return repository.getAllSellers(
      status: status,
      skip: skip,
      limit: limit,
    );
  }
}