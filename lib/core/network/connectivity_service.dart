import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  const ConnectivityService(this._connectivity);

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> get hasInternet async {
    final result = await _connectivity.checkConnectivity();

    return result.any((e) => e != ConnectivityResult.none);
  }
}