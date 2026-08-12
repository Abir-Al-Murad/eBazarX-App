import '../entities/seller_entity.dart';
import '../repositories/seller_repository.dart';

class GetPendingSellersUseCase {
  final SellerRepository repository;

  const GetPendingSellersUseCase(this.repository);

  Future<List<SellerEntity>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return repository.getPendingSellers(
      skip: skip,
      limit: limit,
    );
  }
}