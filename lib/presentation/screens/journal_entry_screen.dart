import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../presentation/providers/tickoff_app_state.dart';
import '../../utils/app_validation.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, required this.habitId});

  final String habitId;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  String? _photoPath;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _photoPath = image.path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<TickOffAppState>().addJournalEntry(
          habitId: widget.habitId,
          note: _noteController.text.trim(),
          photoPath: _photoPath,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final habit = context.watch<TickOffAppState>().habitById(widget.habitId);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.journalEntry)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimen.paddingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (habit != null) ...[
                  Text(habit.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(habit.category),
                  const SizedBox(height: AppDimen.spacing24),
                ],
                TextFormField(
                  controller: _noteController,
                  maxLines: 6,
                  validator: AppValidation.validateJournalNote,
                  decoration: const InputDecoration(
                    labelText: AppStrings.notes,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppDimen.spacing16),
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text(AppStrings.choosePhoto),
                ),
                if (_photoPath != null) ...[
                  const SizedBox(height: AppDimen.spacing12),
                  Text('Selected photo: $_photoPath'),
                ],
                const SizedBox(height: AppDimen.spacing32),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text(AppStrings.save),
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
