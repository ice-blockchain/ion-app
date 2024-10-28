// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/get_user_connect_indexers/providers/user_connect_indexers_notifier.dart';

class GetUserConnectIndexersPage extends HookConsumerWidget {
  const GetUserConnectIndexersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdController = useTextEditingController();
    useListenable(userIdController);

    final indexers = ref.watch(userConnectIndexersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get user connect indexers'),
        actions: [
          if (indexers.isLoading)
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
          ElevatedButton(
            onPressed: () {
              ref
                  .read(userConnectIndexersNotifierProvider.notifier)
                  .fetchUserConnectIndexers(userIdController.text);
            },
            child: const Text('Get indexers'),
          ),
          if (indexers.valueOrNull != null) ...[
            const SizedBox(height: 8),
            ...indexers.valueOrNull!.map((indexer) => Text(indexer)),
          ],
        ],
      ),
    );
  }
}
