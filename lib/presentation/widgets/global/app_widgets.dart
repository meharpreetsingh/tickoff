import 'package:flutter/material.dart';

import '../../../data/models/habit_model.dart';
import '../../../data/models/journal_entry_model.dart';
import '../../../utils/app_function.dart';
import '../../../utils/constants/app_dimen.dart';
import '../../../utils/constants/app_strings.dart';
import '../../../config/theme/app_colors.dart';
import '../../providers/tickoff_app_state.dart';

Color colorFromHex(String hexColor) {
  var value = hexColor.replaceAll('#', '').trim();
  if (value.length == 6) {
    value = 'FF$value';
  }
  return Color(int.parse(value, radix: 16));
}

String hexFromColor(Color color) {
  return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: AppDimen.spacing4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimen.paddingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimen.radiusXl),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimen.paddingSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimen.radiusLg),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: AppDimen.spacing16),
          Text(value, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppDimen.spacing4),
          Text(label, style: theme.textTheme.bodyLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimen.spacing4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimen.paddingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimen.paddingXl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: AppDimen.iconXl, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: AppDimen.spacing24),
            Text(title,
                style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppDimen.spacing8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimen.spacing24),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.completed,
    required this.onCompleteToggle,
    required this.onTap,
    this.onEdit,
    this.onArchive,
    this.onJournal,
  });

  final HabitModel habit;
  final bool completed;
  final VoidCallback onCompleteToggle;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onJournal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = colorFromHex(habit.color);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimen.radiusXl),
      child: Container(
        padding: const EdgeInsets.all(AppDimen.paddingLg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimen.radiusXl),
          border: Border.all(
            color: completed
                ? habitColor
                : theme.dividerColor.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: habitColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimen.radiusLg),
                  ),
                  child: Text(habit.icon, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: AppDimen.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              habit.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onCompleteToggle,
                            icon: Icon(
                              completed
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: completed
                                  ? AppColors.success
                                  : theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      if (habit.description.isNotEmpty)
                        Text(
                          AppFunction.truncate(habit.description, length: 90),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimen.spacing16),
            Wrap(
              spacing: AppDimen.spacing8,
              runSpacing: AppDimen.spacing8,
              children: [
                _Pill(label: habit.category, color: habitColor),
                _Pill(
                    label: '${habit.currentStreak} day streak',
                    color: AppColors.secondary),
                if (habit.reminderEnabled && habit.reminderTime != null)
                  _Pill(label: habit.reminderTime!, color: AppColors.warning),
                if (habit.paused)
                  _Pill(label: 'Paused', color: AppColors.grey500),
                if (habit.archived)
                  _Pill(label: 'Archived', color: AppColors.error),
              ],
            ),
            if (onEdit != null || onArchive != null || onJournal != null) ...[
              const SizedBox(height: AppDimen.spacing12),
              Wrap(
                spacing: AppDimen.spacing8,
                runSpacing: AppDimen.spacing8,
                children: [
                  if (onJournal != null)
                    OutlinedButton.icon(
                      onPressed: onJournal,
                      icon: const Icon(Icons.note_add_outlined),
                      label: const Text('Journal'),
                    ),
                  if (onEdit != null)
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                  if (onArchive != null)
                    OutlinedButton.icon(
                      onPressed: onArchive,
                      icon: Icon(habit.archived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined),
                      label: Text(habit.archived ? 'Restore' : 'Archive'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class JournalTile extends StatelessWidget {
  const JournalTile({
    super.key,
    required this.entry,
    required this.habit,
    this.onTap,
  });

  final JournalEntryModel entry;
  final HabitModel habit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = colorFromHex(habit.color);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimen.paddingLg,
        vertical: AppDimen.paddingSm,
      ),
      leading: CircleAvatar(
        backgroundColor: habitColor.withValues(alpha: 0.15),
        child: Text(habit.icon),
      ),
      title: Text(habit.name),
      subtitle: Text(
        entry.note?.isNotEmpty == true
            ? entry.note!
            : AppStrings.noJournalEntries,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        AppFunction.getReadableTimeDifference(entry.createdAt),
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class TimelineItemCard extends StatelessWidget {
  const TimelineItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final TimelineItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = colorFromHex(item.habit.color);
    final isCompletion = item.kind == TimelineItemKind.completion;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: habitColor.withValues(alpha: 0.15),
          child: Text(item.habit.icon),
        ),
        title: Text(item.habit.name),
        subtitle: Text(
          isCompletion
              ? 'Completed ${AppFunction.formatTime(item.timestamp)}'
              : item.journalEntry?.note ??
                  'Journaled ${AppFunction.formatTime(item.timestamp)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppFunction.formatDate(item.timestamp),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              isCompletion ? 'Done' : 'Note',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isCompletion ? AppColors.success : AppColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimen.paddingSm,
        vertical: AppDimen.paddingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimen.radiusCircle),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppDimen.fontSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
