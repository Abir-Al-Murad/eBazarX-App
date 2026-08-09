import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';

class ListAdminBannersUseCase {
  final BannerRepository _repository;

  ListAdminBannersUseCase(this._repository);

  Future<List<BannerEntity>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return _repository.listOfBannersAdmin(
      skip: skip,
      limit: limit,
    );
  }
}