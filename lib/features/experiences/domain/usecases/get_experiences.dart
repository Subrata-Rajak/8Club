import '../entities/experience.dart';
import '../repositories/experiences_repository.dart';

/// Use case to get all experiences
class GetExperiences {
  final ExperiencesRepository repository;

  GetExperiences(this.repository);

  Future<List<Experience>> call() async {
    return await repository.getExperiences();
  }
}

