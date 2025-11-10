import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/connectivity_bloc/connectivity_bloc.dart';
import '../network/connectivity_bloc/connectivity_state.dart';

/// Widget that displays a banner when there's no internet connection
class ConnectivityBanner extends StatelessWidget {
  final Widget child;

  const ConnectivityBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (previous, current) {
        // Only rebuild when state actually changes (not on initial state)
        return !current.isInitial;
      },
      builder: (context, state) {
        // Don't show banner on initial state
        if (state.isInitial) {
          return child;
        }
        
        final isDisconnected = state is ConnectivityDisconnected;
        
        return Stack(
          children: [
            child,
            if (isDisconnected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.red,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'No internet connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

