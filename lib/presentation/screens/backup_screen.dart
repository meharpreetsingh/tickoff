import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../providers/tickoff_app_state.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _importController = TextEditingController();
  String _exportJson = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBackup());
  }

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _loadBackup() async {
    _exportJson = await context.read<TickOffAppState>().exportBackupJson();
    if (mounted) setState(() {});
  }

  Future<void> _import() async {
    final input = _importController.text.trim();
    if (input.isEmpty) return;
    await context.read<TickOffAppState>().restoreFromBackupJson(input);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.backupComplete)),
    );
    await _loadBackup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.cloudBackup)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimen.paddingXl),
        children: [
          Text(AppStrings.exportData,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimen.spacing12),
          SelectableText(
              _exportJson.isEmpty ? 'Loading backup...' : _exportJson),
          const SizedBox(height: AppDimen.spacing24),
          TextField(
            controller: _importController,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: AppStrings.importData,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppDimen.spacing16),
          ElevatedButton(
              onPressed: _import, child: const Text(AppStrings.importData)),
        ],
      ),
    );
  }
}
