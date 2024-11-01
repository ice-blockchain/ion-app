// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/set_user_connect_relays/providers/set_user_connect_relays_notifier.dart';

class SetUserConnectRelaysPage extends HookConsumerWidget {
  const SetUserConnectRelaysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdController = useTextEditingController();
    final followeeListController = useTextEditingController();
    useListenable(userIdController);
    useListenable(followeeListController);

    final relaysState = ref.watch(setUserConnectRelaysNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set user connect relays'),
        actions: [
          if (relaysState.isLoading)
            const IconButton(
              onPressed: null,
              icon: CircularProgressIndicator(),
            ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          TextField(
            controller: userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: followeeListController,
            decoration: const InputDecoration(
              labelText: 'Followee List (comma separated)',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final followeeList = followeeListController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

              ref.read(setUserConnectRelaysNotifierProvider.notifier).setUserConnectRelays(
                    userId: userIdController.text,
                    followeeList: followeeList,
                  );
            },
            child: const Text('Set relays'),
          ),
          if (relaysState.valueOrNull != null) ...[
            const SizedBox(height: 8),
            Text('Updated relays: ${relaysState.valueOrNull!.ionConnectRelays}'),
          ],
        ],
      ),
    );
  }
}
