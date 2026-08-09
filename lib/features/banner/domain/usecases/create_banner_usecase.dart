import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';

class CreateBannerUseCase {
  final BannerRepository _repository;

  CreateBannerUseCase(this._repository);

  Future<BannerEntity> call({
    required String title,
    String? description,
    required String imageUrl,
    String? linkUrl,
    String? productId,
    String? categoryId,
    required int position,
    required bool isActive,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.createBanner(
      title: title,
      description: description,
      imageUrl: imageUrl,
      linkUrl: linkUrl,
      productId: productId,
      categoryId: categoryId,
      position: position,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
    );
  }
}