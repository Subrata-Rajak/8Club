import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/injection_container.dart' as di;
import 'core/network/connectivity_bloc/connectivity_bloc.dart';
import 'core/network/connectivity_bloc/connectivity_state.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_text_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar style to white icons for the whole app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // White icons (Android)
      statusBarBrightness: Brightness.dark, // Dark style = light/white icons (iOS)
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectivityBloc>.value(
      value: di.getIt<ConnectivityBloc>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // White icons (Android)
          statusBarBrightness: Brightness.dark, // Dark style = light/white icons (iOS)
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: MaterialApp.router(
          title: '8Club Onboarding',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: AppTextStyles.fontFamily,
            textTheme: AppTextStyles.textTheme,
          ),
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return BlocListener<ConnectivityBloc, ConnectivityState>(
              bloc: di.getIt<ConnectivityBloc>(),
              listenWhen: (previous, current) {
                // Only show snackbar when transitioning from connected to disconnected
                // Don't show on initial state or when transitioning from disconnected to connected
                return previous is ConnectivityConnected && 
                       current is ConnectivityDisconnected;
              },
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No internet connection'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
