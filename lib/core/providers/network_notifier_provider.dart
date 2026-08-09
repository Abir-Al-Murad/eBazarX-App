import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ebazarx/core/network/connectivity_service.dart';
import 'package:ebazarx/core/providers/connectivity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum NetworkStatus { online, offline }

class NetworkNotifier extends StateNotifier<NetworkStatus> {
  final ConnectivityService _service;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkNotifier(this._service) : super(NetworkStatus.online) {
    _initialize();
    _subscription = _service.onConnectivityChanged.listen((results) {
      final isOnline = results.any(
            (result) => result != ConnectivityResult.none,
      );
      state = isOnline ? NetworkStatus.online : NetworkStatus.offline;
    });
  }

  Future<void> _initialize() async {
    final hasInternet = await _service.hasInternet;
    state = hasInternet ? NetworkStatus.online : NetworkStatus.offline;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final networkProvider = StateNotifierProvider<NetworkNotifier, NetworkStatus>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return NetworkNotifier(connectivityService);
});