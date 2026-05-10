import 'package:flutter/material.dart';

import '../../utils/constants/app_const.dart';
import '../../utils/constants/app_dimen.dart';
import '../../utils/constants/app_strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.about)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimen.paddingXl),
        children: [
          Text(AppStrings.appName,
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppDimen.spacing12),
          Text(AppStrings.appTagline,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDimen.spacing24),
          Card(
            child: Column(
              children: const [
                ListTile(
                    title: Text('Version'),
                    subtitle: Text(AppConstant.appVersion)),
                ListTile(
                    title: Text('Build'),
                    subtitle: Text(AppConstant.buildNumber)),
                ListTile(
                    title: Text('Architecture'),
                    subtitle: Text('MVVM + Provider + go_router')),
                ListTile(title: Text('Storage'), subtitle: Text('Local-first')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
