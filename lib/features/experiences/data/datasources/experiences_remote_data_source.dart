import '../../../../core/network/http_service.dart';
import '../models/experience_model.dart';

/// Remote data source for experiences
abstract class ExperiencesRemoteDataSource {
  Future<List<ExperienceModel>> getExperiences();
}

class ExperiencesRemoteDataSourceImpl implements ExperiencesRemoteDataSource {
  final HttpService httpService;

  ExperiencesRemoteDataSourceImpl(this.httpService);

  @override
  Future<List<ExperienceModel>> getExperiences() async {
    try {
      final response = await httpService.get(
        '/v1/experiences',
        queryParameters: {'active': 'true'},
      );

      // Parse nested structure: response.data.experiences
      List<dynamic> experiencesList = [];
      
      if (response.containsKey('data')) {
        final dataValue = response['data'];
        if (dataValue is Map<String, dynamic> && dataValue.containsKey('experiences')) {
          final experiences = dataValue['experiences'];
          if (experiences is List) {
            experiencesList = experiences;
          }
        } else if (dataValue is List) {
          // Fallback: if data is directly a list
          experiencesList = dataValue;
        }
      } else if (response.containsKey('results')) {
        final resultsValue = response['results'];
        if (resultsValue is List) {
          experiencesList = resultsValue;
        }
      }

      return experiencesList
          .map((json) => ExperienceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch experiences: $e');
    }
  }
}

