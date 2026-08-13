import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/profile/domain/usecases/apply_for_seller_application_usecase.dart';
import 'package:ebazarx/features/profile/presentation/states/apply_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyNotifier extends StateNotifier<ApplyState> {
  final ApplyForSellerUseCase _applyUseCase;

  ApplyNotifier(this._applyUseCase) : super(ApplyState());

  Future<void> applyForSeller({
    required String shopName,
    required String shopSlug,
    String? description,
    String? logo,
    String? coverImage,
    required String phone,
    required String email,
    required String address,
    required String city,
    required String district,
    String country = 'Bangladesh',
    String? tradeLicense,
    String? nid,
    String? tin,
  }) async {
    state = state.copyWith(isApplying: true, clearError: true);

    try {
      final result = await _applyUseCase.call(
        shopName: shopName,
        shopSlug: shopSlug,
        description: description,
        logo: logo,
        coverImage: coverImage,
        phone: phone,
        email: email,
        address: address,
        city: city,
        district: district,
        country: country,
        tradeLicense: tradeLicense,
        nid: nid,
        tin: tin,
      );

      state = state.copyWith(
        isApplying: false,
        application: result,
        clearError: true,
      );
    } on Failure catch (e) {
      state = state.copyWith(isApplying: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isApplying: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }
}
