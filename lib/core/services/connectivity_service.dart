import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around `connectivity_plus` for the parts of the app that need
/// to know whether the device currently has a network interface.
///
/// Note: this reports interface state (wifi / mobile / none), not actual
/// internet reachability. A device on WiFi without internet still reads as
/// "online". The actual HTTP layer surfaces real failures via `NetworkException`,
/// so this service is best used as a *pre-flight* hint — gating user actions to
/// avoid the obvious offline case — not as a guarantee of reachability.
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Single-shot check. Returns true when at least one connectivity interface
  /// is active (anything other than `none`).
  static Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Stream of online/offline transitions. Emits `true` when at least one
  /// interface is active, `false` otherwise. Useful for reacting to the user
  /// regaining network without polling.
  static Stream<bool> onChange() {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.any((r) => r != ConnectivityResult.none),
    );
  }
}
