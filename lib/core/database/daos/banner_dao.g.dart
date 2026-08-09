// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_dao.dart';

// ignore_for_file: type=lint
mixin _$BannerDaoMixin on DatabaseAccessor<AppDatabase> {
  $BannerTableTable get bannerTable => attachedDatabase.bannerTable;
  BannerDaoManager get managers => BannerDaoManager(this);
}

class BannerDaoManager {
  final _$BannerDaoMixin _db;
  BannerDaoManager(this._db);
  $$BannerTableTableTableManager get bannerTable =>
      $$BannerTableTableTableManager(_db.attachedDatabase, _db.bannerTable);
}
