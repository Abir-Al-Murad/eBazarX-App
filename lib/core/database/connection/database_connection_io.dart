import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor createConnection() {
  return driftDatabase(
    name: 'ebazar.db',
    native: const DriftNativeOptions(),
  );
}