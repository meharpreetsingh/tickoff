import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../utils/app_function.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/enums/router_enums.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        final dueHabits = state.todayHabits;
        final activeHabits = state.activeHabits;
        final completedHabits = state.completedTodayHabits;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appName),
            actions: [
              IconButton(
                tooltip: AppStrings.navTimeline,
                onPressed: () => context.goNamed(RouteNames.timeline),
                icon: const Icon(Icons.timeline_outlined),
              ),
              IconButton(
                tooltip: AppStrings.analyticsTitle,
                onPressed: () => context.goNamed(RouteNames.analytics),
                icon: const Icon(Icons.insights_outlined),
              ),
              IconButton(
                tooltip: AppStrings.settingsTitle,
                onPressed: () => context.goNamed(RouteNames.settings),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.goNamed(RouteNames.addHabit),
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addHabit),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: state.load,
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimen.paddingXl),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimen.paddingXl),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(AppDimen.radiusXxl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppFunction.getReadableTimeDifference(
                                  DateTime.now()),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Keep the streak alive.',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${dueHabits.length} habits due today · ${completedHabits.length} completed',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimen.spacing24),
                      GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 700 ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: AppDimen.gridSpacing,
                        crossAxisSpacing: AppDimen.gridSpacing,
                        childAspectRatio: 1.15,
                        children: [
                          AppStatCard(
                            label: 'Due today',
                            value: '${dueHabits.length}',
                            icon: Icons.today_outlined,
                            color: AppColors.info,
                            subtitle: 'Ready to complete',
                          ),
                          AppStatCard(
                            label: 'Completed',
                            value: '${completedHabits.length}',
                            icon: Icons.check_circle_outline,
                            color: AppColors.success,
                            subtitle: 'Today',
                          ),
                          AppStatCard(
                            label: 'Completion rate',
                            value:
                                '${(state.completionRate * 100).toStringAsFixed(0)}%',
                            icon: Icons.pie_chart_outline,
                            color: AppColors.accent,
                            subtitle: 'Due habits',
                          ),
                          AppStatCard(
                            label: 'Best streak',
                            value: '${state.streakLeader?.bestStreak ?? 0}',
                            icon: Icons.local_fire_department_outlined,
                            color: AppColors.error,
                            subtitle:
                                state.streakLeader?.name ?? 'No habits yet',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimen.spacing24),
                      AppSectionHeader(
                        title: AppStrings.dueHabitsLabel,
                        subtitle: 'Tap the check to mark a habit complete.',
                        actionLabel: 'Add',
                        onAction: () => context.goNamed(RouteNames.addHabit),
                      ),
                      const SizedBox(height: AppDimen.spacing12),
                      if (dueHabits.isEmpty)
                        AppEmptyState(
                          title: AppStrings.noHabits,
                          description: AppStrings.noHabitsDesc,
                          icon: Icons.check_circle_outline,
                          actionLabel: AppStrings.addHabit,
                          onAction: () => context.goNamed(RouteNames.addHabit),
                        )
                      else
                        ...dueHabits.map(
                          (habit) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimen.spacing12),
                            child: HabitCard(
                              habit: habit,
                              completed: habit.isCompletedToday(),
                              onTap: () => context.goNamed(
                                RouteNames.habitDetail,
                                pathParameters: {'id': habit.id},
                              ),
                              onCompleteToggle: () async {
                                final notifier =
                                    context.read<TickOffAppState>();
                                if (habit.isCompletedToday()) {
                                  await notifier.undoCompletion(habit.id);
                                } else {
                                  await notifier.markComplete(habit.id);
                                }
                              },
                              onEdit: () => context.goNamed(
                                RouteNames.editHabit,
                                pathParameters: {'id': habit.id},
                              ),
                              onJournal: () => context.goNamed(
                                RouteNames.journalEntry,
                                pathParameters: {'habitId': habit.id},
                              ),
                              onArchive: () async {
                                final notifier =
                                    context.read<TickOffAppState>();
                                if (habit.archived) {
                                  await notifier.restoreHabit(habit.id);
                                } else {
                                  await notifier.archiveHabit(habit.id);
                                }
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: AppDimen.spacing24),
                      AppSectionHeader(
                        title: AppStrings.allHabitsLabel,
                        subtitle: '${activeHabits.length} active habits',
                        actionLabel: 'View archive',
                        onAction: () => context.goNamed(RouteNames.settings),
                      ),
                      const SizedBox(height: AppDimen.spacing12),
                      if (activeHabits.isEmpty)
                        AppEmptyState(
                          title: AppStrings.noHabits,
                          description: AppStrings.noHabitsDesc,
                          icon: Icons.playlist_add,
                          actionLabel: AppStrings.addHabit,
                          onAction: () => context.goNamed(RouteNames.addHabit),
                        )
                      else
                        ...activeHabits.take(5).map(
                              (habit) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppDimen.spacing12),
                                child: HabitCard(
                                  habit: habit,
                                  completed: habit.isCompletedToday(),
                                  onTap: () => context.goNamed(
                                    RouteNames.habitDetail,
                                    pathParameters: {'id': habit.id},
                                  ),
                                  onCompleteToggle: () async {
                                    final notifier =
                                        context.read<TickOffAppState>();
                                    if (habit.isCompletedToday()) {
                                      await notifier.undoCompletion(habit.id);
                                    } else {
                                      await notifier.markComplete(habit.id);
                                    }
                                  },
                                  onEdit: () => context.goNamed(
                                    RouteNames.editHabit,
                                    pathParameters: {'id': habit.id},
                                  ),
                                  onJournal: () => context.goNamed(
                                    RouteNames.journalEntry,
                                    pathParameters: {'habitId': habit.id},
                                  ),
                                  onArchive: () async {
                                    final notifier =
                                        context.read<TickOffAppState>();
                                    if (habit.archived) {
                                      await notifier.restoreHabit(habit.id);
                                    } else {
                                      await notifier.archiveHabit(habit.id);
                                    }
                                  },
                                ),
                              ),
                            ),
                      const SizedBox(height: AppDimen.spacing32),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
