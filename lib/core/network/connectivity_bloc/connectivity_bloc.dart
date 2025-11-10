import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

/// BLoC for managing connectivity state
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService connectivityService;
  bool _hasCompletedInitialCheck = false;

  ConnectivityBloc({required this.connectivityService})
      : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);

    // First check connectivity, then start listening
    // This ensures we have the correct initial state before listening to changes
    add(CheckConnectivity());
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    final hasConnection = await connectivityService.hasConnection();
    if (hasConnection) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
    
    // Mark that initial check is complete
    _hasCompletedInitialCheck = true;
    
    // After checking connectivity, start listening to changes
    // This ensures we have the correct initial state first
    add(StartListening());
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Capture the current state before starting to listen
    // This is the state set by our initial CheckConnectivity
    final initialState = state;
    bool isFirstEmission = true;
    
    // Use emit.forEach to properly handle stream emissions within event handler context
    // This ensures all emit calls happen within the event handler, preventing the assertion error
    // The event handler will remain active while the stream is active
    // When a new StartListening event is received, the previous handler is cancelled automatically
    await emit.forEach<bool>(
      connectivityService.connectivityStream,
      onData: (isConnected) {
        // Skip the first emission if we've already completed the initial check
        // This prevents the stream from overriding our accurate initial check
        // The stream might emit immediately when subscribed, which could be incorrect
        if (isFirstEmission && _hasCompletedInitialCheck) {
          isFirstEmission = false;
          // Return the initial state we captured, not the stream's first value
          return initialState;
        }
        
        isFirstEmission = false;
        
        if (isConnected) {
          return ConnectivityConnected();
        } else {
          return ConnectivityDisconnected();
        }
      },
    );
  }

  void _onStopListening(
    StopListening event,
    Emitter<ConnectivityState> emit,
  ) {
    // Note: emit.forEach automatically cancels when a new event is processed
    // or when the BLoC is closed. No manual subscription management needed.
  }
}

