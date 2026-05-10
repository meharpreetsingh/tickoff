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

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        final habit = state.habitById(habitId);
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Habit detail')),
            body: AppEmptyState(
              title: 'Habit not found',
              description: 'The habit may have been deleted.',
              icon: Icons.error_outline,
              actionLabel: 'Back home',
              onAction: () => context.goNamed(RouteNames.home),
            ),
          );
        }

        final entries = state.journalEntriesForHabit(habit.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            actions: [
              IconButton(
                onPressed: () => context.goNamed(
                  RouteNames.editHabit,
                  pathParameters: {'id': habit.id},
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () async {
                  final notifier = context.read<TickOffAppState>();
                  if (habit.archived) {
                    await notifier.restoreHabit(habit.id);
                  } else {
                    await notifier.archiveHabit(habit.id);
                  }
                },
                icon: Icon(habit.archived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined),
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete habit?'),
                      content: Text(AppStrings.confirmDelete),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(AppStrings.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(AppStrings.delete),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await context.read<TickOffAppState>().deleteHabit(habit.id);
                    if (context.mounted) {
                      context.goNamed(RouteNames.home);
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimen.paddingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimen.paddingXl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorFromHex(habit.color),
                        colorFromHex(habit.color).withValues(alpha: 0.65),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimen.radiusXxl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.icon, style: const TextStyle(fontSize: 44)),
                      const SizedBox(height: 12),
                      Text(
                        habit.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        habit.description.isEmpty
                            ? 'No description yet'
                            : habit.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Pill(
                              label: habit.category,
                              background: Colors.white.withValues(alpha: 0.2)),
                          _Pill(
                              label: '${habit.currentStreak} streak',
                              background: Colors.white.withValues(alpha: 0.2)),
                          _Pill(
                              label: '${habit.totalCompletions} completions',
                              background: Colors.white.withValues(alpha: 0.2)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimen.spacing24),
                Wrap(
                  spacing: AppDimen.spacing8,
                  runSpacing: AppDimen.spacing8,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        final notifier = context.read<TickOffAppState>();
                        if (habit.isCompletedToday()) {
                          await notifier.undoCompletion(habit.id);
                        } else {
                          await notifier.markComplete(habit.id);
                        }
                      },
                      icon: Icon(
                          habit.isCompletedToday() ? Icons.undo : Icons.check),
                      label: Text(habit.isCompletedToday()
                          ? AppStrings.undoCompletion
                          : AppStrings.markAsComplete),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.goNamed(
                        RouteNames.journalEntry,
                        pathParameters: {'habitId': habit.id},
                      ),
                      icon: const Icon(Icons.note_add_outlined),
                      label: const Text(AppStrings.journalEntry),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.goNamed(
                        RouteNames.habitJournal,
                        pathParameters: {'habitId': habit.id},
                      ),
                      icon: const Icon(Icons.book_outlined),
                      label: const Text(AppStrings.journalEntries),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final notifier = context.read<TickOffAppState>();
                        await notifier.togglePaused(habit.id);
                      },
                      icon: Icon(habit.paused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_outlined),
                      label: Text(habit.paused ? 'Resume' : 'Pause'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimen.spacing24),
                const AppSectionHeader(title: 'Quick stats'),
                const SizedBox(height: AppDimen.spacing12),
                GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 700 ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppDimen.gridSpacing,
                  crossAxisSpacing: AppDimen.gridSpacing,
                  childAspectRatio: 1.25,
                  children: [
                    AppStatCard(
                      label: 'Current streak',
                      value: '${habit.currentStreak}',
                      icon: Icons.local_fire_department_outlined,
                      color: AppColors.error,
                      subtitle: 'days',
                    ),
                    AppStatCard(
                      label: 'Best streak',
                      value: '${habit.bestStreak}',
                      icon: Icons.emoji_events_outlined,
                      color: AppColors.accent,
                      subtitle: 'days',
                    ),
                    AppStatCard(
                      label: 'Last done',
                      value: habit.lastCompletedAt.year == 1970
                          ? 'Never'
                          : AppFunction.formatDate(habit.lastCompletedAt),
                      icon: Icons.event_available_outlined,
                      color: AppColors.success,
                      subtitle: 'Latest completion',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimen.spacing24),
                AppSectionHeader(
                  title: AppStrings.journalEntries,
                  subtitle: '${entries.length} entries',
                  actionLabel: 'Add',
                  onAction: () => context.goNamed(
                    RouteNames.journalEntry,
                    pathParameters: {'habitId': habit.id},
                  ),
                ),
                const SizedBox(height: AppDimen.spacing12),
                if (entries.isEmpty)
                  AppEmptyState(
                    title: AppStrings.noJournalEntries,
                    description:
                        'Add a quick reflection to remember what worked.',
                    icon: Icons.book_outlined,
                    actionLabel: AppStrings.addNote,
                    onAction: () => context.goNamed(
                      RouteNames.journalEntry,
                      pathParameters: {'habitId': habit.id},
                    ),
                  )
                else
                  ...entries.map(
                    (entry) => Card(
                      child: ListTile(
                        title: Text(entry.note?.isNotEmpty == true
                            ? entry.note!
                            : 'No note'),
                        subtitle: Text(AppFunction.formatDate(entry.createdAt)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await context
                                .read<TickOffAppState>()
                                .deleteJournalEntry(entry.id);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}
