import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/services/ion_identity/ion_identity_logger.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/nostr/nostr_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: const Text('🐞 Debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ExpansionTile(
              title: const Text('Logs'),
              children: [
                ListTile(
                  title: const Text('App logs'),
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/${Logger.logFileName}');

                    if (file.existsSync()) {
                      await Share.shareXFiles([XFile(file.path)]);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No logs found'),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  title: const Text('ION Identity Client'),
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/${IonIdentityLogger.logFileName}');

                    if (file.existsSync()) {
                      await Share.shareXFiles([XFile(file.path)]);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No logs found'),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  title: const Text('Nostr'),
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/${NostrLogger.logFileName}');

                    if (file.existsSync()) {
                      await Share.shareXFiles([XFile(file.path)]);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No logs found'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
