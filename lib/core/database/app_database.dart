import 'package:drift/drift.dart';

import 'package:ebazarx/core/database/daos/banner_dao.dart';
import 'package:ebazarx/core/database/tables/banner/banner_table.dart';

import 'connection/database_connection.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BannerTable,
  ],
  daos: [
    BannerDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createConnection());

  @override
  int get schemaVersion => 1;
}