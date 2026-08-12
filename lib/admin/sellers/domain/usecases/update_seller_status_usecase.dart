import '../entities/seller_entity.dart';
import '../repositories/seller_repository.dart';

class UpdateSellerStatusUseCase {
  final SellerRepository repository;

  const UpdateSellerStatusUseCase(this.repository);

  Future<SellerEntity> call({
    required String sellerId,
    required String status,
    String? adminNotes,
  }) {
    return repository.updateSellerStatus(
      sellerId: sellerId,
      status: status,
      adminNotes: adminNotes,
    );
  }
}