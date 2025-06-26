// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/keys/providers/create_key_notifier.r.dart';
import 'package:ion_identity_client_example/pages/keys/providers/derive_notifier.r.dart';

class KeysMainPage extends HookConsumerWidget {
  const KeysMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createKeyState = ref.watch(createKeyNotifierProvider);

    final body = createKeyState.when(
      data: (data) => 'Keys',
      error: (error, stack) => 'Error: $error',
      loading: () => 'Creating key...',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keys'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(createKeyNotifierProvider.notifier).createKey();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(body),
            TextButton(
              onPressed: () {
                ref.read(deriveKeyNotifierProvider.notifier).derive();
              },
              child: const Text('Derive key'),
            ),
          ],
        ),
      ),
    );
  }
}
