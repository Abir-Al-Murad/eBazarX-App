import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/usecases/fetch_banners_usecase.dart';
import 'package:ebazarx/features/banner/presentation/states/public_banner_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PublicBannerListNotifier extends StateNotifier<PublicBannerListState> {
  final FetchBannersUseCase _fetchBannersUseCase;
  PublicBannerListNotifier(this._fetchBannersUseCase) : super(const PublicBannerListState());
  Future<void> fetchBanners() async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      print("Fetching Banners...");
      final banners = await _fetchBannersUseCase();
      print("Total Banners from Notifier: ${banners.length}");
      state = state.copyWith(
        isLoading: false,
        banners: banners,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    }
  }

  void clearBannerList(){
    state = const PublicBannerListState();
  }
}