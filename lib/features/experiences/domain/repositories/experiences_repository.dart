import '../entities/experience.dart';

/// Repository interface for experiences - domain layer
abstract class ExperiencesRepository {
  /// Get all active experiences
  Future<List<Experience>> getExperiences();
}

