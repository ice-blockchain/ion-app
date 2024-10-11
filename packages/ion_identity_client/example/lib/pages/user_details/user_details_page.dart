// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/user_wallets/user_wallets_page.dart';
import 'package:ion_client_example/providers/current_username_notifier.dart';

class UserDetailsPage extends HookConsumerWidget {
  const UserDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUsernameNotifierProvider) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Wallets'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserWalletsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
