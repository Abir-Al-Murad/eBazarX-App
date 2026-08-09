import 'package:drift/drift.dart';
import 'package:ebazarx/core/database/app_database.dart';
import 'package:ebazarx/core/database/tables/banner/banner_table.dart';

part 'banner_dao.g.dart';

@DriftAccessor(tables: [BannerTable])
class BannerDao extends DatabaseAccessor<AppDatabase> with _$BannerDaoMixin {
  BannerDao(super.db);

  // =====================================
  // CACHE BANNERS (SYNC)
  // =====================================

  Future<void> cacheBanners(List<BannerTableCompanion> banners) async {
    await transaction(() async {
      // remove old cache

      await delete(bannerTable).go();

      // insert latest cache

      await batch((batch) {
        batch.insertAll(bannerTable, banners, mode: InsertMode.insertOrReplace);
      });
      print("Cached");
    });
  }

  // =====================================
  // GET PUBLIC ACTIVE BANNERS
  // =====================================

  Future<List<BannerTableData>> getActiveBanners() {
    final now = DateTime.now();

    return (select(bannerTable)
          ..where((tbl) {
            return tbl.isActive.equals(true) &
                (tbl.startDate.isNull() |
                    tbl.startDate.isSmallerOrEqualValue(now)) &
                (tbl.endDate.isNull() | tbl.endDate.isBiggerOrEqualValue(now));
          })
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.position, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // =====================================
  // GET ALL CACHED BANNERS
  // =====================================

  Future<List<BannerTableData>> getAllBanners() {
    return (select(bannerTable)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.position, mode: OrderingMode.asc),
        ]))
        .get();
  }

  // =====================================
  // DELETE SINGLE BANNER
  // =====================================

  Future<int> deleteBannerById(String id) {
    return (delete(bannerTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  // =====================================
  // CLEAR CACHE
  // =====================================

  Future<int> clearCache() {
    return delete(bannerTable).go();
  }
}
