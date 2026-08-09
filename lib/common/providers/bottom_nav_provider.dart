

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/bottom_nav_notifier.dart';

final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>((ref) => BottomNavNotifier(0));