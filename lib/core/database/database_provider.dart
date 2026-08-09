import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebazarx/core/database/app_database.dart';
import 'package:ebazarx/core/database/daos/banner_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() async {
    await database.close();
  });

  return database;
});

final bannerDaoProvider = Provider<BannerDao>((ref) {
  return BannerDao(ref.read(databaseProvider));
});