import 'package:go_router/go_router.dart';
import '../../features/experiences/presentation/screens/get_started_screen.dart';
import '../../features/experiences/presentation/screens/experience_selection_screen.dart';
import '../../features/experiences/presentation/screens/onboarding_question_screen.dart';
import '../../features/experiences/presentation/screens/thank_you_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';

/// App router configuration using go_router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.getStarted,
    routes: [
      GoRoute(
        path: RoutePaths.getStarted,
        name: RouteNames.getStarted,
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: RoutePaths.experiences,
        name: RouteNames.experiences,
        builder: (context, state) => const ExperienceSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingQuestion,
        name: RouteNames.onboardingQuestion,
        builder: (context, state) => const OnboardingQuestionScreen(),
      ),
      GoRoute(
        path: RoutePaths.thankYou,
        name: RouteNames.thankYou,
        builder: (context, state) => const ThankYouScreen(),
      ),
    ],
  );
}

