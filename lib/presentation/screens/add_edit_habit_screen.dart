import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/category_model.dart';
import '../../data/models/habit_model.dart';
import '../../presentation/providers/tickoff_app_state.dart';
import '../../utils/app_function.dart';
import '../../utils/app_validation.dart';
import '../../config/theme/app_colors.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/enums/storage_enums.dart' as storage;
import '../widgets/global/app_widgets.dart';

class AddEditHabitScreen extends StatefulWidget {
  const AddEditHabitScreen({super.key, this.habitId});

  final String? habitId;

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  String _selectedIcon = '📝';
  String _selectedColor = '#6366F1';
  storage.HabitSchedule _selectedSchedule = storage.HabitSchedule.daily;
  CategoryModel? _selectedCategory;
  bool _reminderEnabled = false;
  TimeOfDay? _reminderTime;
  HabitModel? _editingHabit;

  final _icons = const [
    '📝',
    '💧',
    '📚',
    '🏃',
    '🚶',
    '🧘',
    '🍎',
    '☀️',
    '🌙',
    '💻'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHabit());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadHabit() {
    final state = context.read<TickOffAppState>();
    if (widget.habitId != null) {
      _editingHabit = state.habitById(widget.habitId!);
    }

    final habit = _editingHabit;
    if (habit != null) {
      _nameController.text = habit.name;
      _descriptionController.text = habit.description;
      _selectedIcon = habit.icon;
      _selectedColor = habit.color;
      _selectedSchedule = habit.schedule;
      _reminderEnabled = habit.reminderEnabled;
      _reminderTime = _parseReminderTime(habit.reminderTime);
      final category = state.categories.cast<CategoryModel?>().firstWhere(
            (category) =>
                category?.id == habit.categoryId ||
                category?.name == habit.category,
            orElse: () =>
                state.categories.isNotEmpty ? state.categories.first : null,
          );
      _selectedCategory = category;
    } else {
      _selectedCategory =
          state.categories.isNotEmpty ? state.categories.first : null;
    }

    if (mounted) {
      setState(() {});
    }
  }

  TimeOfDay? _parseReminderTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() => _reminderTime = time);
    }
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a category.')),
      );
      return;
    }

    final state = context.read<TickOffAppState>();
    final now = DateTime.now();
    final existing = _editingHabit;
    final habit = HabitModel(
      id: existing?.id ?? AppFunction.generateUuid(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      categoryId: _selectedCategory?.id,
      category: _selectedCategory?.name ?? 'General',
      schedule: _selectedSchedule,
      reminderTime: _reminderEnabled && _reminderTime != null
          ? _formatTimeOfDay(_reminderTime!)
          : null,
      reminderEnabled: _reminderEnabled,
      archived: existing?.archived ?? false,
      paused: existing?.paused ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      currentStreak: existing?.currentStreak ?? 0,
      bestStreak: existing?.bestStreak ?? 0,
      lastCompletedAt:
          existing?.lastCompletedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      totalCompletions: existing?.totalCompletions ?? 0,
      journalEntryIds: existing?.journalEntryIds,
    );

    await state.upsertHabit(habit);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(existing == null
              ? AppStrings.habitCreated
              : AppStrings.habitUpdated)),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = context.watch<TickOffAppState>().categories;
    final title = _editingHabit == null ? AppStrings.addHabit : AppStrings.edit;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimen.paddingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: AppValidation.validateHabitName,
                  decoration: const InputDecoration(
                    labelText: AppStrings.habitName,
                    prefixIcon: Icon(Icons.edit_note_outlined),
                  ),
                ),
                const SizedBox(height: AppDimen.spacing16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: AppDimen.spacing24),
                Text(AppStrings.selectIcon, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppDimen.spacing12),
                Wrap(
                  spacing: AppDimen.spacing8,
                  runSpacing: AppDimen.spacing8,
                  children: _icons.map((icon) {
                    final selected = _selectedIcon == icon;
                    return ChoiceChip(
                      label: Text(icon),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedIcon = icon),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimen.spacing24),
                Text(AppStrings.selectColor,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: AppDimen.spacing12),
                Wrap(
                  spacing: AppDimen.spacing8,
                  runSpacing: AppDimen.spacing8,
                  children: AppColors.habitColors.map((color) {
                    final colorHex = hexFromColor(color);
                    final selected =
                        _selectedColor.toUpperCase() == colorHex.toUpperCase();
                    return InkWell(
                      onTap: () => setState(() => _selectedColor = colorHex),
                      borderRadius:
                          BorderRadius.circular(AppDimen.radiusCircle),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: selected
                                ? theme.colorScheme.onSurface
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimen.spacing24),
                DropdownButtonFormField<CategoryModel>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: AppStrings.selectCategory,
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (category) =>
                      setState(() => _selectedCategory = category),
                ),
                const SizedBox(height: AppDimen.spacing24),
                DropdownButtonFormField<storage.HabitSchedule>(
                  initialValue: _selectedSchedule,
                  decoration: const InputDecoration(
                    labelText: AppStrings.selectSchedule,
                    prefixIcon: Icon(Icons.repeat_outlined),
                  ),
                  items: storage.HabitSchedule.values
                      .map(
                        (schedule) => DropdownMenuItem(
                          value: schedule,
                          child: Text(AppFunction.capitalize(schedule.value)),
                        ),
                      )
                      .toList(),
                  onChanged: (schedule) {
                    if (schedule != null) {
                      setState(() => _selectedSchedule = schedule);
                    }
                  },
                ),
                const SizedBox(height: AppDimen.spacing24),
                SwitchListTile.adaptive(
                  title: const Text(AppStrings.enableReminder),
                  value: _reminderEnabled,
                  onChanged: (value) =>
                      setState(() => _reminderEnabled = value),
                ),
                if (_reminderEnabled) ...[
                  const SizedBox(height: AppDimen.spacing12),
                  OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time_outlined),
                    label: Text(_reminderTime == null
                        ? AppStrings.reminderTime
                        : _reminderTime!.format(context)),
                  ),
                ],
                const SizedBox(height: AppDimen.spacing32),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(AppStrings.save),
                ),
                const SizedBox(height: AppDimen.spacing12),
                TextButton(
                  onPressed: context.pop,
                  child: const Text(AppStrings.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
