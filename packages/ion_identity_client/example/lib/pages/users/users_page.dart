// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client_example/pages/user_details/user_details_page.dart';
import 'package:ion_identity_client_example/pages/users/components/users_menu.dart';
import 'package:ion_identity_client_example/pages/users/providers/logout_action_notifier.r.dart';
import 'package:ion_identity_client_example/pages/users/providers/users_provider.r.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: const [UsersMenu()],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return users.when(
      data: (users) => users.isEmpty
          ? const Center(
              child: Text('No users'),
            )
          : ListView(
              children: [
                for (final user in users)
                  ListTile(
                    title: Text(user),
                    onTap: () {
                      ref.read(currentUsernameNotifierProvider.notifier).setUsername(user);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserDetailsPage(),
                        ),
                      );
                    },
                    trailing: GestureDetector(
                      onTap: () {
                        ref.read(logoutActionNotifierProvider.notifier).logOut(keyName: user);
                      },
                      child: const Text("logout"),
                    ),
                  ),
              ],
            ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('$error'),
      ),
    );
  }
}
