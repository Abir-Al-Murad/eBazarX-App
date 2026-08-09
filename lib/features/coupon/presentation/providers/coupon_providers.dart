
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/coupon/data/datasources/coupon_remote_datasource.dart';
import 'package:ebazarx/features/coupon/data/repositories/coupon_repository_impl.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:ebazarx/features/coupon/domain/usecases/validate_coupon_usecase.dart';
import 'package:ebazarx/features/coupon/presentation/notifiers/validate_coupon_notifier.dart';
import 'package:ebazarx/features/coupon/presentation/states/validate_coupon_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final couponRemoteDataSourceProvider = Provider<CouponRemoteDatasource>((ref) => CouponRemoteDatasource(ref.read(apiClientProvider)));
final couponRepositoryProvider = Provider<CouponRepository>((ref) => CouponRepositoryImpl(ref.read(couponRemoteDataSourceProvider)));
final validCouponUseCaseProvider = Provider<ValidateCouponUseCase>((ref) => ValidateCouponUseCase(ref.read(couponRepositoryProvider)));

final validCouponProvider = StateNotifierProvider<ValidateCouponNotifier, ValidateCouponState>((ref) => ValidateCouponNotifier(ref.read(validCouponUseCaseProvider)));