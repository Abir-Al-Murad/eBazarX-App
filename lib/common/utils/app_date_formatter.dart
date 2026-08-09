import 'package:intl/intl.dart';

class AppDateFormatter {
  AppDateFormatter._();

  static final DateFormat _yyyyMMdd = DateFormat('yyyy-MM-dd');

  static String format(DateTime date) {
    return _yyyyMMdd.format(date);
  }

  static String? formatNullable(DateTime? date) {
    if (date == null) return null;
    return _yyyyMMdd.format(date);
  }
}