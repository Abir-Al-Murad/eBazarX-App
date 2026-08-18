import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';

class FetchBannersUseCase {
  final BannerRepository _repository;
  FetchBannersUseCase(this._repository);
  Future<List<BannerEntity>> call() async {
    return await _repository.fetchBanners();
  }
}