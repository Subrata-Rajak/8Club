import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity
abstract class ConnectivityService {
  /// Check current connectivity status
  Future<bool> hasConnection();

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream;

  /// Get current connectivity result
  Future<ConnectivityResult> getConnectivityResult();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl(this._connectivity);

  @override
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && 
           results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.isNotEmpty && 
                   results.any((result) => result != ConnectivityResult.none),
    );
  }

  @override
  Future<ConnectivityResult> getConnectivityResult() async {
    final results = await _connectivity.checkConnectivity();
    // Return the first result, or none if empty
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }
}

