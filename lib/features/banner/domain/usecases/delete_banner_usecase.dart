import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';

class DeleteBannerUseCase {
  final BannerRepository _repository;

  DeleteBannerUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteBanner(id);
  }
}