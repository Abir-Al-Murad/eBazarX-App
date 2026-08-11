import 'package:ebazarx/admin/banners/notifiers/admin_banner_list_notifier.dart';
import 'package:ebazarx/admin/banners/notifiers/admin_banner_notifier.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_list_state.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_state.dart';
import 'package:ebazarx/features/banner/domain/usecases/create_banner_usecase.dart';
import 'package:ebazarx/features/banner/domain/usecases/delete_banner_usecase.dart';
import 'package:ebazarx/features/banner/domain/usecases/list_admin_banners_usecase.dart';
import 'package:ebazarx/features/banner/domain/usecases/update_banner_usecase.dart';
import 'package:ebazarx/features/banner/presentation/providers/banner_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createBannerUseCase = Provider<CreateBannerUseCase>((ref) {
  return CreateBannerUseCase(ref.read(bannerRepositoryProvider));
});

final updateBannerUseCase = Provider<UpdateBannerUseCase>((ref) {
  return UpdateBannerUseCase(ref.read(bannerRepositoryProvider));
});

final deleteBannerUseCase = Provider<DeleteBannerUseCase>((ref) {
  return DeleteBannerUseCase(ref.read(bannerRepositoryProvider));
});

final listAdminBannersUseCase = Provider<ListAdminBannersUseCase>((ref) {
  return ListAdminBannersUseCase(ref.read(bannerRepositoryProvider));
});

final adminBannerListNotifierProvider = StateNotifierProvider<AdminBannerListNotifier, AdminBannerListState>((ref) {
  return AdminBannerListNotifier(ref.read(listAdminBannersUseCase));
});

final adminBannerNotifierProvider = StateNotifierProvider<AdminBannerNotifier, AdminBannerState>((ref) {
  return AdminBannerNotifier(
    ref.read(updateBannerUseCase),
    ref.read(deleteBannerUseCase),
    ref.read(createBannerUseCase),
  );
});