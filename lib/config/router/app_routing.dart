import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/about_screen.dart';
import '../../presentation/screens/add_edit_habit_screen.dart';
import '../../presentation/screens/analytics_screen.dart';
import '../../presentation/screens/backup_screen.dart';
import '../../presentation/screens/habit_detail_screen.dart';
import '../../presentation/screens/habit_journal_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/journal_entry_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/timeline_screen.dart';
import '../../presentation/screens/splash_screen.dart';
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
            return const SplashScreen();
          },
        ),

        // Onboarding
        GoRoute(
          path: RouterEnum.onboarding.path,
          name: RouteNames.onboarding,
          builder: (context, state) {
            return const OnboardingScreen();
          },
        ),

        // Home
        GoRoute(
          path: RouterEnum.home.path,
          name: RouteNames.home,
          builder: (context, state) {
            return const HomeScreen();
          },
          routes: [
            // Add Habit
            GoRoute(
              path: RouterEnum.addHabit.path.replaceFirst('/', ''),
              name: RouteNames.addHabit,
              builder: (context, state) {
                return const AddEditHabitScreen();
              },
            ),

            // Edit Habit
            GoRoute(
              path: RouterEnum.editHabit.path.replaceFirst('/', ''),
              name: RouteNames.editHabit,
              builder: (context, state) {
                final habitId = state.pathParameters['id'];
                return AddEditHabitScreen(habitId: habitId);
              },
            ),

            // Habit Detail
            GoRoute(
              path: RouterEnum.habitDetail.path.replaceFirst('/', ''),
              name: RouteNames.habitDetail,
              builder: (context, state) {
                final habitId = state.pathParameters['id']!;
                return HabitDetailScreen(habitId: habitId);
              },
              routes: [
                // Habit Journal
                GoRoute(
                  path: RouterEnum.habitJournal.path.replaceFirst('/', ''),
                  name: RouteNames.habitJournal,
                  builder: (context, state) {
                    final habitId = state.pathParameters['habitId']!;
                    return HabitJournalScreen(habitId: habitId);
                  },
                ),
              ],
            ),

            // Journal Entry
            GoRoute(
              path: RouterEnum.journalEntry.path.replaceFirst('/', ''),
              name: RouteNames.journalEntry,
              builder: (context, state) {
                final habitId = state.pathParameters['habitId']!;
                return JournalEntryScreen(habitId: habitId);
              },
            ),
          ],
        ),

        // Timeline
        GoRoute(
          path: RouterEnum.timeline.path,
          name: RouteNames.timeline,
          builder: (context, state) {
            return const TimelineScreen();
          },
        ),

        // Analytics
        GoRoute(
          path: RouterEnum.analytics.path,
          name: RouteNames.analytics,
          builder: (context, state) {
            return const AnalyticsScreen();
          },
        ),

        // Settings
        GoRoute(
          path: RouterEnum.settings.path,
          name: RouteNames.settings,
          builder: (context, state) {
            return const SettingsScreen();
          },
          routes: [
            // Backup
            GoRoute(
              path: RouterEnum.backup.path.replaceFirst('/', ''),
              name: RouteNames.backup,
              builder: (context, state) {
                return const BackupScreen();
              },
            ),

            // About
            GoRoute(
              path: RouterEnum.about.path.replaceFirst('/', ''),
              name: RouteNames.about,
              builder: (context, state) {
                return const AboutScreen();
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
