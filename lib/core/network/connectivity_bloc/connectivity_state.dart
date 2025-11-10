/// Base class for connectivity states
abstract class ConnectivityState {
  /// Whether this is the initial state (before first check)
  bool get isInitial => this is ConnectivityInitial;
}

/// Initial connectivity state (before first connectivity check)
class ConnectivityInitial extends ConnectivityState {}

/// Connected state
class ConnectivityConnected extends ConnectivityState {}

/// Disconnected state
class ConnectivityDisconnected extends ConnectivityState {}

