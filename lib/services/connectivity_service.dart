import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around connectivity_plus so the rest of the app depends
/// on a simple boolean rather than the plugin's API directly.
///
/// NOTE: targets connectivity_plus ^5.0.2, where checkConnectivity()
/// and the change stream return a single [ConnectivityResult] (not a
/// List as in v6+). If you upgrade the package major version, switch
/// the `!= ConnectivityResult.none` checks below to `.contains(...)`.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
}
