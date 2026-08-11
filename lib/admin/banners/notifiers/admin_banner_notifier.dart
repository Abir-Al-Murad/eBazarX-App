import 'package:ebazarx/admin/banners/states/admin_banner_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/usecases/create_banner_usecase.dart';
import 'package:ebazarx/features/banner/domain/usecases/delete_banner_usecase.dart';
import 'package:ebazarx/features/banner/domain/usecases/update_banner_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminBannerNotifier extends StateNotifier<AdminBannerState> {
  final UpdateBannerUseCase _updateBannerUseCase;
  final DeleteBannerUseCase _deleteBannerUseCase;
  final CreateBannerUseCase _createBannerUseCase;

  AdminBannerNotifier(
      this._updateBannerUseCase,
      this._deleteBannerUseCase,
      this._createBannerUseCase,
      ) : super(const AdminBannerState());

  // ------------------------------------------------------------
  // UPDATE BANNER
  // ------------------------------------------------------------

  Future<void> updateBanner({
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
  }) async {
    if (state.isUpdating) return;

    state = state.copyWith(
      isUpdating: true,
      clearFailure: true,
    );

    try {
      await _updateBannerUseCase(
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

      state = state.copyWith(
        isUpdating: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isUpdating: false,
        failure: e,
      );
    } catch (e, s) {
      debugPrint('Update banner error: $e');
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isUpdating: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ------------------------------------------------------------
  // CREATE BANNER
  // ------------------------------------------------------------

  Future<void> createBanner({
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
    if (state.isCreating) return;

    state = state.copyWith(
      isCreating: true,
      clearFailure: true,
    );

    try {
      await _createBannerUseCase(
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

      state = state.copyWith(
        isCreating: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isCreating: false,
        failure: e,
      );
    } catch (e, s) {
      debugPrint('Create banner error: $e');
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isCreating: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ------------------------------------------------------------
  // DELETE BANNER
  // ------------------------------------------------------------

  Future<void> deleteBanner(String id) async {
    if (state.isDeleting) return;

    state = state.copyWith(
      isDeleting: true,
      clearFailure: true,
    );

    try {
      await _deleteBannerUseCase(id);

      state = state.copyWith(
        isDeleting: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isDeleting: false,
        failure: e,
      );
    } catch (e, s) {
      debugPrint('Delete banner error: $e');
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isDeleting: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ------------------------------------------------------------
  // CLEAR ERROR
  // ------------------------------------------------------------

  void clearFailure() {
    state = state.copyWith(
      clearFailure: true,
    );
  }

  // ------------------------------------------------------------
  // RESET STATE
  // ------------------------------------------------------------

  void reset() {
    state = const AdminBannerState();
  }
}