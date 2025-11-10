/// Base class for connectivity events
abstract class ConnectivityEvent {}

/// Event to check connectivity status
class CheckConnectivity extends ConnectivityEvent {}

/// Event to start listening to connectivity changes
class StartListening extends ConnectivityEvent {}

/// Event to stop listening to connectivity changes
class StopListening extends ConnectivityEvent {}

