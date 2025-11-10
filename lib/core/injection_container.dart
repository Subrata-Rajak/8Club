import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'network/http_service.dart';
import 'network/connectivity_service.dart';
import 'network/connectivity_bloc/connectivity_bloc.dart';
import 'storage/local_storage_service.dart';
import '../features/experiences/data/datasources/experiences_remote_data_source.dart';
import '../features/experiences/data/repositories/experiences_repository_impl.dart';
import '../features/experiences/domain/repositories/experiences_repository.dart';
import '../features/experiences/domain/usecases/get_experiences.dart';
import '../features/experiences/presentation/blocs/audio_recording/audio_recording_bloc.dart';
import '../features/experiences/presentation/blocs/experiences/experiences_bloc.dart';
import '../features/experiences/presentation/blocs/video_recording/video_recording_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection container
Future<void> init() async {
  // Core - Storage
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(getIt<SharedPreferences>()),
  );

  // Core - Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(getIt<Connectivity>()),
  );

  // Core - Network
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  
  getIt.registerLazySingleton<HttpService>(
    () => HttpService(
      client: getIt(),
    ),
  );

  // Features - Experiences
  // Data sources
  getIt.registerLazySingleton<ExperiencesRemoteDataSource>(
    () => ExperiencesRemoteDataSourceImpl(getIt<HttpService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ExperiencesRepository>(
    () => ExperiencesRepositoryImpl(getIt<ExperiencesRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetExperiences>(
    () => GetExperiences(getIt<ExperiencesRepository>()),
  );

  // BLoCs - Register as factory so each screen gets its own instance
  getIt.registerFactory<ExperiencesBloc>(
    () => ExperiencesBloc(getExperiences: getIt<GetExperiences>()),
  );

  getIt.registerFactory<AudioRecordingBloc>(
    () => AudioRecordingBloc(),
  );

  getIt.registerFactory<VideoRecordingBloc>(
    () => VideoRecordingBloc(),
  );

  // Connectivity BLoC - Singleton as it should be app-wide
  getIt.registerLazySingleton<ConnectivityBloc>(
    () => ConnectivityBloc(
      connectivityService: getIt<ConnectivityService>(),
    ),
  );
}

