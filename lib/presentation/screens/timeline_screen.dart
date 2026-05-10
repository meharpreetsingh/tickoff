import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';
import '../providers/tickoff_app_state.dart';
import '../widgets/global/app_widgets.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TickOffAppState>(
      builder: (context, state, _) {
        final items = state.timelineItems;

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.navTimeline)),
          body: items.isEmpty
              ? AppEmptyState(
                  title: AppStrings.timelineEmpty,
                  description:
                      'Your completions and journal entries will appear here.',
                  icon: Icons.timeline_outlined,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimen.paddingXl),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimen.spacing12),
                  itemBuilder: (context, index) =>
                      TimelineItemCard(item: items[index]),
                ),
        );
      },
    );
  }
}
