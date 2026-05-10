import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/enums/router_enums.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    final state = context.read<TickOffAppState>();
    await state.setOnboardingCompleted(true);
    if (context.mounted) {
      context.goNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cards = [
      (
        icon: Icons.local_fire_department_outlined,
        title: 'Streaks that feel alive',
        description: 'See every habit at a glance and keep the momentum going.'
      ),
      (
        icon: Icons.check_circle_outline,
        title: 'One-tap completion',
        description: 'Mark habits complete instantly and track progress daily.'
      ),
      (
        icon: Icons.book_outlined,
        title: 'Micro-journaling',
        description:
            'Attach notes and photos to capture the story behind each win.'
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimen.radiusXxl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.onboardingTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Build better habits with a focused, visual system.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimen.spacing24),
              ...cards.map(
                (card) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimen.spacing16),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimen.paddingLg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppDimen.radiusXl),
                      border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimen.paddingSm),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppDimen.radiusLg),
                          ),
                          child:
                              Icon(card.icon, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: AppDimen.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(card.title,
                                  style: theme.textTheme.titleMedium),
                              const SizedBox(height: 6),
                              Text(
                                card.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimen.spacing8),
              const AppSectionHeader(
                title: 'What you can do',
                subtitle: 'Track, journal, review, and keep going.',
              ),
              const SizedBox(height: AppDimen.spacing12),
              Wrap(
                spacing: AppDimen.spacing8,
                runSpacing: AppDimen.spacing8,
                children: const [
                  _FeatureChip(label: 'Habit streaks'),
                  _FeatureChip(label: 'Daily check-ins'),
                  _FeatureChip(label: 'Journal notes'),
                  _FeatureChip(label: 'Analytics'),
                  _FeatureChip(label: 'Backup & restore'),
                ],
              ),
              const SizedBox(height: AppDimen.spacing32),
              ElevatedButton(
                onPressed: () => _finish(context),
                child: const Text(AppStrings.getStarted),
              ),
              const SizedBox(height: AppDimen.spacing12),
              TextButton(
                onPressed: () => _finish(context),
                child: const Text(AppStrings.skip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      side: BorderSide.none,
    );
  }
}
