import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_experiences.dart';
import 'experiences_event.dart';
import 'experiences_state.dart';

/// BLoC for managing experiences state
class ExperiencesBloc extends Bloc<ExperiencesEvent, ExperiencesState> {
  final GetExperiences getExperiences;

  ExperiencesBloc({required this.getExperiences}) : super(ExperiencesInitial()) {
    on<FetchExperiences>(_onFetchExperiences);
    on<ToggleExperienceSelection>(_onToggleExperienceSelection);
    on<UpdateExperienceNote>(_onUpdateExperienceNote);
    on<SubmitExperiences>(_onSubmitExperiences);
  }

  Future<void> _onFetchExperiences(
    FetchExperiences event,
    Emitter<ExperiencesState> emit,
  ) async {
    emit(ExperiencesLoading());
    try {
      final experiences = await getExperiences();
      emit(ExperiencesLoaded(experiences: experiences));
    } catch (e) {
      emit(ExperiencesError(e.toString()));
    }
  }

  void _onToggleExperienceSelection(
    ToggleExperienceSelection event,
    Emitter<ExperiencesState> emit,
  ) {
    if (state is ExperiencesLoaded) {
      final currentState = state as ExperiencesLoaded;
      final selectedIds = Set<int>.from(currentState.selectedIds);
      
      if (selectedIds.contains(event.experienceId)) {
        // Allow unselecting
        selectedIds.remove(event.experienceId);
      } else {
        // Only allow selecting if less than 3 are already selected
        if (selectedIds.length < 3) {
          selectedIds.add(event.experienceId);
        }
        // If 3 are already selected, do nothing (stamp will be disabled)
      }

      emit(currentState.copyWith(selectedIds: selectedIds));
    }
  }

  void _onUpdateExperienceNote(
    UpdateExperienceNote event,
    Emitter<ExperiencesState> emit,
  ) {
    if (state is ExperiencesLoaded) {
      final currentState = state as ExperiencesLoaded;
      emit(currentState.copyWith(note: event.note));
    }
  }

  void _onSubmitExperiences(
    SubmitExperiences event,
    Emitter<ExperiencesState> emit,
  ) {
    // Log the payload for now
    debugPrint('Submitting experiences:');
    debugPrint('Selected IDs: ${event.selectedIds}');
    debugPrint('Note: ${event.note}');
    
    // TODO: Implement actual submission to API
    // This will be handled by navigation in the screen
  }
}

