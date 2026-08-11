import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';

class AdminBannerListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<BannerEntity> banners;
  final bool hasMore;
  final Failure? failure;

  AdminBannerListState({
     this.isLoading = false,
     this.isLoadingMore = false,
     this.banners = const [],
     this.hasMore = true,
    this.failure,
  });
  
  AdminBannerListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<BannerEntity>? banners,
    bool? hasMore,
    Failure? failure,
    bool? clearError = false,
  }) {
    return AdminBannerListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      banners: banners ?? this.banners,
      hasMore: hasMore ?? this.hasMore,
      failure: clearError == true ? null : failure ?? this.failure,
    );
  }
}