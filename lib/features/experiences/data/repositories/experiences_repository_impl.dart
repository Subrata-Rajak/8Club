import '../../domain/entities/experience.dart';
import '../../domain/repositories/experiences_repository.dart';
import '../datasources/experiences_remote_data_source.dart';

/// Implementation of ExperiencesRepository
class ExperiencesRepositoryImpl implements ExperiencesRepository {
  final ExperiencesRemoteDataSource remoteDataSource;

  ExperiencesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Experience>> getExperiences() async {
    try {
      final models = await remoteDataSource.getExperiences();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get experiences: $e');
    }
  }
}

