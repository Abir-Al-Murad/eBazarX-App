import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';

class PublicBannerListState {
  final bool isLoading;
  final List<BannerEntity> banners;
  final Failure? failure;

  const PublicBannerListState({
    this.isLoading = false,
    this.banners = const [],
    this.failure,
  });

  PublicBannerListState copyWith({
    bool? isLoading,
    List<BannerEntity>? banners,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return PublicBannerListState(
      isLoading: isLoading ?? this.isLoading,
      banners: banners ?? this.banners,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}