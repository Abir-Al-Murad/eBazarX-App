import 'package:ebazarx/core/database/daos/banner_dao.dart';
import 'package:ebazarx/core/database/database_provider.dart';
import 'package:ebazarx/core/network/api_client.dart';

import 'package:ebazarx/features/banner/data/datasources/banner_local_datasource.dart';
import 'package:ebazarx/features/banner/data/datasources/banner_remote_data_source.dart';

import 'package:ebazarx/features/banner/data/repositories/banner_repository_impl.dart';

import 'package:ebazarx/features/banner/domain/repositories/banner_repository.dart';
import 'package:ebazarx/features/banner/domain/usecases/fetch_banners_usecase.dart';

import 'package:ebazarx/features/banner/presentation/notifiers/public_banner_list_notifier.dart';
import 'package:ebazarx/features/banner/presentation/states/public_banner_list_state.dart';

import 'package:ebazarx/core/providers/connectivity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// ============================
// Data Sources
// ============================

final bannerRemoteDataSourceProvider = Provider<BannerRemoteDataSource>((ref) {
  return BannerRemoteDataSource(ref.watch(apiClientProvider));
});

final bannerLocalDataSourceProvider = Provider<BannerLocalDataSource>((ref) {
  return BannerLocalDataSource(ref.watch(bannerDaoProvider));
});

// ============================
// Repository
// ============================

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepositoryImpl(
    ref.watch(bannerRemoteDataSourceProvider),

    ref.read(bannerLocalDataSourceProvider),
      ref.read(connectivityServiceProvider),
  );
});

// ============================
// UseCase
// ============================

final publicBannerListUseCaseProvider = Provider<FetchBannersUseCase>((ref) {
  return FetchBannersUseCase(ref.read(bannerRepositoryProvider));
});

// ============================
// Notifier
// ============================

final publicBannerListNotifierProvider =
    StateNotifierProvider<PublicBannerListNotifier, PublicBannerListState>((
      ref,
    ) {
      return PublicBannerListNotifier(
        ref.read(publicBannerListUseCaseProvider),
      );
    });
