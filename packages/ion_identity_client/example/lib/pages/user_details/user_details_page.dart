// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/get_user_connect_indexers/get_user_connect_indexers_page.dart';
import 'package:ion_client_example/pages/get_user_details/get_user_details_page.dart';
import 'package:ion_client_example/pages/set_user_connect_relays/set_user_connect_relays_page.dart';
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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GetUserDetailsPage(),
                    ),
                  ),
                  child: const Text('Get user details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GetUserConnectIndexersPage(),
                    ),
                  ),
                  child: const Text('Get user connect indexers'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SetUserConnectRelaysPage(),
                    ),
                  ),
                  child: const Text('Set user connect relays'),
                ),
              ],
            ),
          ),
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
