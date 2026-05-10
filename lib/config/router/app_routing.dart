import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/enums/router_enums.dart';

/// Global navigation key for contextless navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// App routing configuration
class AppRouting {
  /// Create router
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RouterEnum.splash.path,
      redirect: (context, state) {
        // Add redirect logic here for authentication flow
        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: RouterEnum.splash.path,
          name: RouteNames.splash,
          builder: (context, state) {
            // TODO: Implement splash screen
            return const Placeholder();
          },
        ),

        // Onboarding
        GoRoute(
          path: RouterEnum.onboarding.path,
          name: RouteNames.onboarding,
          builder: (context, state) {
            // TODO: Implement onboarding screen
            return const Placeholder();
          },
        ),

        // Home
        GoRoute(
          path: RouterEnum.home.path,
          name: RouteNames.home,
          builder: (context, state) {
            // TODO: Implement home screen
            return const Placeholder();
          },
          routes: [
            // Add Habit
            GoRoute(
              path: RouterEnum.addHabit.path.replaceFirst('/', ''),
              name: RouteNames.addHabit,
              builder: (context, state) {
                // TODO: Implement add habit screen
                return const Placeholder();
              },
            ),

            // Edit Habit
            GoRoute(
              path: RouterEnum.editHabit.path.replaceFirst('/', ''),
              name: RouteNames.editHabit,
              builder: (context, state) {
                // final habitId = state.pathParameters['id'];
                // TODO: Implement edit habit screen
                return const Placeholder();
              },
            ),

            // Habit Detail
            GoRoute(
              path: RouterEnum.habitDetail.path.replaceFirst('/', ''),
              name: RouteNames.habitDetail,
              builder: (context, state) {
                // final habitId = state.pathParameters['id'];
                // TODO: Implement habit detail screen
                return const Placeholder();
              },
              routes: [
                // Habit Journal
                GoRoute(
                  path: RouterEnum.habitJournal.path.replaceFirst('/', ''),
                  name: RouteNames.habitJournal,
                  builder: (context, state) {
                    // final habitId = state.pathParameters['habitId'];
                    // TODO: Implement habit journal screen
                    return const Placeholder();
                  },
                ),
              ],
            ),

            // Journal Entry
            GoRoute(
              path: RouterEnum.journalEntry.path.replaceFirst('/', ''),
              name: RouteNames.journalEntry,
              builder: (context, state) {
                // final habitId = state.pathParameters['habitId'];
                // TODO: Implement journal entry screen
                return const Placeholder();
              },
            ),
          ],
        ),

        // Timeline
        GoRoute(
          path: RouterEnum.timeline.path,
          name: RouteNames.timeline,
          builder: (context, state) {
            // TODO: Implement timeline screen
            return const Placeholder();
          },
        ),

        // Analytics
        GoRoute(
          path: RouterEnum.analytics.path,
          name: RouteNames.analytics,
          builder: (context, state) {
            // TODO: Implement analytics screen
            return const Placeholder();
          },
        ),

        // Settings
        GoRoute(
          path: RouterEnum.settings.path,
          name: RouteNames.settings,
          builder: (context, state) {
            // TODO: Implement settings screen
            return const Placeholder();
          },
          routes: [
            // Backup
            GoRoute(
              path: RouterEnum.backup.path.replaceFirst('/', ''),
              name: RouteNames.backup,
              builder: (context, state) {
                // TODO: Implement backup screen
                return const Placeholder();
              },
            ),

            // About
            GoRoute(
              path: RouterEnum.about.path.replaceFirst('/', ''),
              name: RouteNames.about,
              builder: (context, state) {
                // TODO: Implement about screen
                return const Placeholder();
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: ${state.error}')),
        );
      },
    );
  }

  /// Navigate to home
  static void navigateToHome() {
    navigatorKey.currentContext?.goNamed(RouteNames.home);
  }

  /// Navigate to add habit
  static void navigateToAddHabit() {
    navigatorKey.currentContext?.goNamed(
      RouteNames.addHabit,
      extra: {'from': RouteNames.home},
    );
  }

  /// Navigate to edit habit
  static void navigateToEditHabit(String habitId) {
    navigatorKey.currentContext?.goNamed(
      RouteNames.editHabit,
      pathParameters: {'id': habitId},
    );
  }

  /// Navigate to habit detail
  static void navigateToHabitDetail(String habitId) {
    navigatorKey.currentContext?.goNamed(
      RouteNames.habitDetail,
      pathParameters: {'id': habitId},
    );
  }

  /// Navigate to journal entry
  static void navigateToJournalEntry(String habitId) {
    navigatorKey.currentContext?.goNamed(
      RouteNames.journalEntry,
      pathParameters: {'habitId': habitId},
    );
  }

  /// Navigate to timeline
  static void navigateToTimeline() {
    navigatorKey.currentContext?.goNamed(RouteNames.timeline);
  }

  /// Navigate to analytics
  static void navigateToAnalytics() {
    navigatorKey.currentContext?.goNamed(RouteNames.analytics);
  }

  /// Navigate to settings
  static void navigateToSettings() {
    navigatorKey.currentContext?.goNamed(RouteNames.settings);
  }

  /// Go back
  static void goBack() {
    if (navigatorKey.currentContext?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }
}
