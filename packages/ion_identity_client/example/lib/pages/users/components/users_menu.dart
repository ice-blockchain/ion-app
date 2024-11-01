// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion_identity_client_example/pages/login/login_page.dart';
import 'package:ion_identity_client_example/pages/login_delegated/delegated_login_page.dart';
import 'package:ion_identity_client_example/pages/register/register_page.dart';

class UsersMenu extends HookWidget {
  const UsersMenu({super.key});

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
          MenuItemButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DelegatedLoginPage(),
                ),
              );
            },
            child: const Text('Delegated Login'),
          ),
        ],
        child: const Icon(Icons.person),
      ),
    );
  }
}
