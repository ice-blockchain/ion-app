// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';

class TwoFAPage extends HookConsumerWidget {
  const TwoFAPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final codeController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TwoFA'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final currentUser = ref.watch(currentUsernameNotifierProvider);
              final ionIdentity = await ref.read(ionIdentityProvider.future);

              ionIdentity(username: currentUser!).auth.requestTwoFACode(
                    twoFAType: TwoFAType.email(emailController.text),
                    onVerifyIdentity: ({
                      required onBiometricsFlow,
                      required onPasskeyFlow,
                      required onPasswordFlow,
                    }) =>
                        onPasskeyFlow(),
                  );
            },
            child: const Text('Init TwoFA'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Code'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final currentUser = ref.watch(currentUsernameNotifierProvider);
              final ionIdentity = await ref.read(ionIdentityProvider.future);

              ionIdentity(username: currentUser!)
                  .auth
                  .verifyTwoFA(TwoFAType.email(codeController.text));
            },
            child: const Text('Complete TwoFA'),
          ),
        ],
      ),
    );
  }
}
