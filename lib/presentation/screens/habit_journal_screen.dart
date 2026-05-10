import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/app_function.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/enums/router_enums.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class HabitJournalScreen extends StatelessWidget {
  const HabitJournalScreen({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        final habit = state.habitById(habitId);
        final entries = state.journalEntriesForHabit(habitId);

        if (habit == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.journalEntries)),
            body: const Center(child: Text('Habit not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${habit.name} journal'),
            actions: [
              IconButton(
                onPressed: () => context.goNamed(
                  RouteNames.journalEntry,
                  pathParameters: {'habitId': habit.id},
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: entries.isEmpty
              ? AppEmptyState(
                  title: AppStrings.noJournalEntries,
                  description:
                      'Start capturing short notes and photos for this habit.',
                  icon: Icons.book_outlined,
                  actionLabel: AppStrings.addNote,
                  onAction: () => context.goNamed(
                    RouteNames.journalEntry,
                    pathParameters: {'habitId': habit.id},
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimen.paddingXl),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimen.spacing12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
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
                    );
                  },
                ),
        );
      },
    );
  }
}
