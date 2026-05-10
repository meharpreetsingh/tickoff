import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        final bestHabit = state.bestHabit;
        final leader = state.streakLeader;
        final weeklyValues = _weeklyCompletionCounts(state);
        final maxValue = weeklyValues.isEmpty
            ? 1
            : weeklyValues.reduce((a, b) => a > b ? a : b).clamp(1, 999);

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.analyticsTitle)),
          body: state.activeHabits.isEmpty
              ? AppEmptyState(
                  title: AppStrings.noAnalytics,
                  description:
                      'Complete a few habits to populate the dashboard.',
                  icon: Icons.insights_outlined,
                )
              : ListView(
                  padding: const EdgeInsets.all(AppDimen.paddingXl),
                  children: [
                    GridView.count(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 700 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppDimen.gridSpacing,
                      crossAxisSpacing: AppDimen.gridSpacing,
                      childAspectRatio: 1.1,
                      children: [
                        AppStatCard(
                          label: AppStrings.totalCompleted,
                          value: '${state.totalCompletedCount}',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        AppStatCard(
                          label: AppStrings.completionRate,
                          value:
                              '${(state.completionRate * 100).toStringAsFixed(0)}%',
                          icon: Icons.pie_chart_outline,
                          color: AppColors.info,
                        ),
                        AppStatCard(
                          label: AppStrings.bestHabit,
                          value: bestHabit?.bestStreak.toString() ?? '0',
                          icon: Icons.emoji_events_outlined,
                          color: AppColors.accent,
                          subtitle: bestHabit?.name ?? 'No habit yet',
                        ),
                        AppStatCard(
                          label: 'Current streak',
                          value: leader?.currentStreak.toString() ?? '0',
                          icon: Icons.local_fire_department_outlined,
                          color: AppColors.error,
                          subtitle: leader?.name ?? 'No habit yet',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimen.spacing24),
                    const AppSectionHeader(
                      title: AppStrings.weeklyCompletion,
                      subtitle: 'A simple snapshot of the current week.',
                    ),
                    const SizedBox(height: AppDimen.spacing12),
                    Container(
                      padding: const EdgeInsets.all(AppDimen.paddingLg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppDimen.radiusXl),
                      ),
                      child: Column(
                        children: List.generate(7, (index) {
                          final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final value = weeklyValues[index];
                          final height = 32.0 + (value / maxValue) * 96.0;
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimen.spacing12),
                            child: Row(
                              children: [
                                SizedBox(width: 20, child: Text(days[index])),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        width: value == 0 ? 8 : height,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                    width: 24,
                                    child: Text('$value',
                                        textAlign: TextAlign.end)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: AppDimen.spacing24),
                    const AppSectionHeader(
                      title: 'Best habits',
                      subtitle: 'Your strongest streak leaders.',
                    ),
                    const SizedBox(height: AppDimen.spacing12),
                    ...state.activeHabits.take(5).map(
                          (habit) => Card(
                            child: ListTile(
                              title: Text(habit.name),
                              subtitle: Text(
                                  '${habit.currentStreak} current · ${habit.bestStreak} best'),
                              trailing: Text(habit.icon,
                                  style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                  ],
                ),
        );
      },
    );
  }

  List<int> _weeklyCompletionCounts(TickOffAppState state) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return state.completions.where((completion) {
        final date = completion.completedDate;
        return date.year == day.year &&
            date.month == day.month &&
            date.day == day.day;
      }).length;
    });
  }
}
