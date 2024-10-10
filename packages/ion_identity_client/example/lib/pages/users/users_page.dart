// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_client_example/pages/login/login_page.dart';
import 'package:ion_client_example/pages/register/register_page.dart';
import 'package:ion_client_example/pages/user_details/user_details_page.dart';
import 'package:ion_client_example/pages/users/providers/users_provider.dart';
import 'package:ion_client_example/providers/current_username_notifier.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: const [
          _UsersMenu(),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _UsersMenu extends HookWidget {
  const _UsersMenu();

  @override
  Widget build(BuildContext context) {
    final menuController = useRef(MenuController());

    return IconButton(
      onPressed: () {
        menuController.value.open();
      },
      icon: MenuAnchor(
        controller: menuController.value,
        menuChildren: [
          MenuItemButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            child: const Text('Register'),
          ),
          MenuItemButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Login'),
          ),
        ],
        child: const Icon(Icons.person),
      ),
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
