import 'package:ebazarx/features/coupon/data/datasources/coupon_remote_datasource.dart';
import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDatasource _remoteDataSource;

  const CouponRepositoryImpl(this._remoteDataSource);

  @override
  Future<CouponEntity> validateCoupon({
    required String couponCode,
    required double subtotal,
    required String userId,
  }) {
    return _remoteDataSource.validateCoupon(couponCode, subtotal, userId).then((couponModel) => couponModel.toEntity());
  }
}
