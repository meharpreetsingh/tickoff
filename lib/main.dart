import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'core/services/injector.dart';
import 'utils/constants/app_strings.dart';
import 'presentation/providers/tickoff_app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await setupDependencies();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TickOffAppState(),
      child: const TickOffApp(),
    ),
  );
}

class TickOffApp extends StatelessWidget {
  const TickOffApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();
    final themeMode = context.watch<TickOffAppState>().themeMode;

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
