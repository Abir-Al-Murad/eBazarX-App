import 'package:ebazarx/core/database/daos/banner_dao.dart';
import 'package:ebazarx/features/banner/data/models/banner_model.dart';

class BannerLocalDataSource {
  final BannerDao _dao;

  const BannerLocalDataSource(this._dao);

  // ============================
  // Get Cached Banners
  // ============================

  Future<List<BannerModel>> getCachedBanners() async {
    final result = await _dao.getActiveBanners();

    return result.map((e) => BannerModel.fromTable(e)).toList();
  }

  // ============================
  // Save Banners
  // ============================

  Future<void> cacheBanners(List<BannerModel> banners) async {
    final data = banners.map((e) => e.toCompanion()).toList();

    await _dao.cacheBanners(data);
  }

  // ============================
  // Clear Cache
  // ============================

  Future<void> clearCache() async {
    await _dao.clearCache();
  }
}
