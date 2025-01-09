// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureFlags = ref.watch(featureFlagsProvider);
    final talker = Logger().talker;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          title: const Text('🐞 Debug'),
          showBackButton: false,
          actions: const [NavigationCloseButton()],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [
                if (talker != null)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.bug_report),
                      title: const Text('View Debug Logs'),
                      subtitle: const Text('Check application logs and diagnostics'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<TalkerScreen>(
                          builder: (context) => TalkerScreen(
                            talker: talker,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16.0.s),
                ExpansionTile(
                  title: const Text('Feature Flags'),
                  children: featureFlags.entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(entry.key.key),
                            trailing: Icon(
                              entry.value ? Icons.check_circle : Icons.cancel,
                              color: entry.value ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
