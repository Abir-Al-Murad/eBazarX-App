

import 'package:ebazarx/features/banner/domain/entities/banner.dart';

abstract class BannerRepository {
  Future<List<BannerEntity>> fetchBanners();

  Future<BannerEntity> createBanner({
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
  });

  Future<List<BannerEntity>> listOfBannersAdmin({
    int skip = 0,
    int limit = 20,
  });

  Future<BannerEntity> updateBanner({
    required String id,
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
  });

  Future<void> deleteBanner(String id);
}