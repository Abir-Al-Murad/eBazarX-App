import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/coupon/data/datasources/coupon_remote_datasource.dart';
import 'package:ebazarx/features/coupon/data/repositories/coupon_repository_impl.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:ebazarx/features/coupon/domain/usecases/create_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/delete_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_all_coupons_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_coupon_by_id_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/update_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/domain/usecases/validate_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/presentation/notifiers/validate_coupon_notifier.dart';
import 'package:ebazarx/features/coupon/presentation/states/validate_coupon_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================
// DATA SOURCES & REPOSITORY
// ============================================================

final couponRemoteDataSourceProvider =
Provider<CouponRemoteDatasource>((ref) => CouponRemoteDatasource(ref.read(apiClientProvider)));

final couponRepositoryProvider = Provider<CouponRepository>((ref) => CouponRepositoryImpl(ref.read(couponRemoteDataSourceProvider)));

// ============================================================
// USE CASES
// ============================================================

final validateCouponUseCaseProvider = Provider<ValidateCouponUseCase>((ref) => ValidateCouponUseCase(ref.read(couponRepositoryProvider)));

final createCouponUseCaseProvider = Provider<CreateCouponUseCase>((ref) => CreateCouponUseCase(ref.read(couponRepositoryProvider)));

final getAllCouponsUseCaseProvider = Provider<GetAllCouponsUseCase>((ref) => GetAllCouponsUseCase(ref.read(couponRepositoryProvider)));

final getCouponByIdUseCaseProvider = Provider<GetCouponByIdUseCase>((ref) => GetCouponByIdUseCase(ref.read(couponRepositoryProvider)));

final updateCouponUseCaseProvider = Provider<UpdateCouponUseCase>((ref) => UpdateCouponUseCase(ref.read(couponRepositoryProvider)));

final deleteCouponUseCaseProvider = Provider<DeleteCouponUseCase>((ref) => DeleteCouponUseCase(ref.read(couponRepositoryProvider)));

// ============================================================
// NOTIFIERS (OPTIONAL)
// ============================================================

final validateCouponProvider = StateNotifierProvider<ValidateCouponNotifier, ValidateCouponState>(
      (ref) => ValidateCouponNotifier(ref.read(validateCouponUseCaseProvider)),
);

// Add other notifiers here as needed (e.g., admin coupon list, crud)