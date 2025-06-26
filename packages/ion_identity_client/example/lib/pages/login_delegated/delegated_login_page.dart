// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/login_delegated/providers/delegated_login_notifier.r.dart';

class DelegatedLoginPage extends HookConsumerWidget {
  const DelegatedLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();

    final delegatedLoginState = ref.watch(delegatedLoginNotifierProvider);
    final isLoading = delegatedLoginState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delegated Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: usernameController,
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    ref
                        .read(delegatedLoginNotifierProvider.notifier)
                        .delegatedLogin(username: usernameController.text);
                  },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
