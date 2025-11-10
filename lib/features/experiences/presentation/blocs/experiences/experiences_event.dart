/// Base class for experiences events
abstract class ExperiencesEvent {}

/// Event to fetch experiences from remote
class FetchExperiences extends ExperiencesEvent {}

/// Event to toggle experience selection
class ToggleExperienceSelection extends ExperiencesEvent {
  final int experienceId;

  ToggleExperienceSelection(this.experienceId);
}

/// Event to update the note for selected experiences
class UpdateExperienceNote extends ExperiencesEvent {
  final String note;

  UpdateExperienceNote(this.note);
}

/// Event to submit selected experiences
class SubmitExperiences extends ExperiencesEvent {
  final List<int> selectedIds;
  final String note;

  SubmitExperiences({
    required this.selectedIds,
    required this.note,
  });
}

