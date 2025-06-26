// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/get_ion_connect_indexers/get_ion_connect_indexers_page.dart';
import 'package:ion_identity_client_example/pages/get_user_details/get_user_details_page.dart';
import 'package:ion_identity_client_example/pages/keys/keys_main_page.dart';
import 'package:ion_identity_client_example/pages/set_ion_connect_relays/set_ion_connect_relays_page.dart';
import 'package:ion_identity_client_example/pages/twofa/twofa_page.dart';
import 'package:ion_identity_client_example/pages/user_wallet_views/user_wallet_views_page.dart';
import 'package:ion_identity_client_example/pages/user_wallets/user_wallets_page.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';

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
                      builder: (context) => const GetIONConnectIndexersPage(),
                    ),
                  ),
                  child: const Text('Get user connect indexers'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SetIONConnectRelaysPage(),
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
          ListTile(
            title: const Text('Wallet Views'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserWalletViewsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('2FA'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TwoFAPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Keys'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const KeysMainPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
