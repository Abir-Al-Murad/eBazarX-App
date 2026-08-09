import 'package:drift/drift.dart';

class BannerTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get imageUrl => text()();

  TextColumn get linkUrl => text().nullable()();

  TextColumn get productId => text().nullable()();

  TextColumn get categoryId => text().nullable()();

  IntColumn get position => integer()();

  BoolColumn get isActive => boolean()();

  DateTimeColumn get startDate => dateTime().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
