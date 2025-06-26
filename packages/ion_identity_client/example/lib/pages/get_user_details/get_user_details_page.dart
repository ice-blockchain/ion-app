// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/get_user_details/providers/user_details_notifier.r.dart';

class GetUserDetailsPage extends HookConsumerWidget {
  const GetUserDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdController = useTextEditingController();
    useListenable(userIdController);

    final userDetails = ref.watch(userDetailsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get user details'),
        actions: [
          if (userDetails.isLoading)
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
                  .read(userDetailsNotifierProvider.notifier)
                  .fetchUserDetails(userIdController.text);
            },
            child: const Text('Get user details'),
          ),
          if (userDetails.valueOrNull != null) ...[
            const SizedBox(height: 8),
            Text(userDetails.valueOrNull!.toString()),
          ],
        ],
      ),
    );
  }
}
