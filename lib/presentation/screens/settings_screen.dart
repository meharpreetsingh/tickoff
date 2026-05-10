import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/enums/router_enums.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
          body: ListView(
            padding: const EdgeInsets.all(AppDimen.paddingXl),
            children: [
              const AppSectionHeader(title: AppStrings.general),
              const SizedBox(height: AppDimen.spacing12),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(AppStrings.soundEnabled),
                      value: state.soundEnabled,
                      onChanged: (value) => context
                          .read<TickOffAppState>()
                          .setSoundEnabled(value),
                    ),
                    SwitchListTile(
                      title: const Text(AppStrings.hapticEnabled),
                      value: state.hapticEnabled,
                      onChanged: (value) => context
                          .read<TickOffAppState>()
                          .setHapticEnabled(value),
                    ),
                    ListTile(
                      title: const Text(AppStrings.theme),
                      subtitle: Text(state.themeMode.name),
                      trailing: DropdownButton<ThemeMode>(
                        value: state.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<TickOffAppState>().setThemeMode(value);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text(AppStrings.systemMode)),
                          DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text(AppStrings.lightMode)),
                          DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text(AppStrings.darkMode)),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(AppStrings.weekStartDay),
                      subtitle: Text(_weekdayName(state.weekStartDay)),
                      trailing: DropdownButton<int>(
                        value: state.weekStartDay,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<TickOffAppState>()
                                .setWeekStartDay(value);
                          }
                        },
                        items: List.generate(
                          7,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(_weekdayName(index + 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimen.spacing24),
              const AppSectionHeader(title: AppStrings.data),
              const SizedBox(height: AppDimen.spacing12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(AppStrings.cloudBackup),
                      trailing: Switch(
                        value: state.backupEnabled,
                        onChanged: (value) => context
                            .read<TickOffAppState>()
                            .setBackupEnabled(value),
                      ),
                    ),
                    ListTile(
                      title: const Text(AppStrings.exportData),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.goNamed(RouteNames.backup),
                    ),
                    ListTile(
                      title: const Text(AppStrings.importData),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.goNamed(RouteNames.backup),
                    ),
                    ListTile(
                      title: const Text(AppStrings.deleteAllData),
                      trailing:
                          const Icon(Icons.delete_outline, color: Colors.red),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(AppStrings.deleteAllData),
                            content:
                                const Text(AppStrings.deleteAllDataConfirm),
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
                          await context.read<TickOffAppState>().clearAllData();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimen.spacing24),
              const AppSectionHeader(title: AppStrings.about),
              const SizedBox(height: AppDimen.spacing12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(AppStrings.version),
                      subtitle: const Text('1.0.0'),
                    ),
                    ListTile(
                      title: const Text(AppStrings.about),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.goNamed(RouteNames.about),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }
}
