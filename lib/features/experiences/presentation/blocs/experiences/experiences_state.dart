import '../../../domain/entities/experience.dart';

/// Base class for experiences states
abstract class ExperiencesState {}

/// Initial state
class ExperiencesInitial extends ExperiencesState {}

/// Loading state
class ExperiencesLoading extends ExperiencesState {}

/// Loaded state with experiences list, selected IDs, and note
class ExperiencesLoaded extends ExperiencesState {
  final List<Experience> experiences;
  final Set<int> selectedIds;
  final String note;

  ExperiencesLoaded({
    required this.experiences,
    this.selectedIds = const {},
    this.note = '',
  });

  ExperiencesLoaded copyWith({
    List<Experience>? experiences,
    Set<int>? selectedIds,
    String? note,
  }) {
    return ExperiencesLoaded(
      experiences: experiences ?? this.experiences,
      selectedIds: selectedIds ?? this.selectedIds,
      note: note ?? this.note,
    );
  }
}

/// Error state
class ExperiencesError extends ExperiencesState {
  final String message;

  ExperiencesError(this.message);
}

