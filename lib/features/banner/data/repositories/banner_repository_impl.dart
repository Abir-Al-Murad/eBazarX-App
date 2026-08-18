import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/network/connectivity_service.dart';
import 'package:ebazarx/features/banner/data/datasources/banner_local_datasource.dart';
import 'package:ebazarx/features/banner/data/datasources/banner_remote_data_source.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';
import 'package:flutter/cupertino.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;
  final BannerLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  const BannerRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectivityService,
  );

  @override
  Future<List<BannerEntity>> fetchBanners() async {
    if (await connectivityService.hasInternet) {
      debugPrint("Internet connection available");
      try {
        final remoteBanners = await remoteDataSource.fetchBanners();

        // TODO: replace with localDataSource.replaceAll(remoteBanners)
        await localDataSource.clearCache();
        await localDataSource.cacheBanners(remoteBanners);

        return remoteBanners.map((banner) => banner.toEntity()).toList();
      } catch (e,s) {
        print(s);
        print(e.toString());
        // API failed, fall back to cache.
      }
    }
    debugPrint("Internet connection not available");
    final cachedBanners = await localDataSource.getCachedBanners();
    debugPrint("Cached Banners Length: ${cachedBanners.length}");
    if (cachedBanners.isNotEmpty) {
      return cachedBanners.map((banner) => banner.toEntity()).toList();
    }

    throw const NetworkFailure(
      'No internet connection and no cached banners available.',
    );
  }

  @override
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
  }) async {
    final banner = await remoteDataSource.createBanner(
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

    return banner.toEntity();
  }

  @override
  Future<List<BannerEntity>> listOfBannersAdmin({
    int skip = 0,
    int limit = 20,
  }) async {
    final banners = await remoteDataSource.listOfBannersAdmin(
      skip: skip,
      limit: limit,
    );

    return banners.map((banner) => banner.toEntity()).toList();
  }

  @override
  Future<BannerEntity> updateBanner({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    String? productId,
    String? categoryId,
    int? position,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final banner = await remoteDataSource.updateBanner(
      id: id,
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

    return banner.toEntity();
  }

  @override
  Future<void> deleteBanner(String id) async {
    await remoteDataSource.deleteBanner(id);

    await localDataSource.clearCache();
  }
}
