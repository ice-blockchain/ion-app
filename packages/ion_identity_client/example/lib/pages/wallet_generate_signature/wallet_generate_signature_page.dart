// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/user_wallets/providers/user_wallets_provider.c.dart';
import 'package:ion_identity_client_example/pages/wallet_generate_signature/providers/generate_signature_notifier.c.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.c.dart';

class WalletGenerateSignaturePage extends HookConsumerWidget {
  const WalletGenerateSignaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController();

    final currentUser = ref.watch(currentUsernameNotifierProvider) ?? '';
    final wallets = ref.watch(userWalletsProvider(currentUser));
    final selectedWallet = useState<Wallet?>(wallets.value?.firstOrNull);

    final generateSignatureState = ref.watch(generateSignatureNotifierProvider);
    final isLoading = generateSignatureState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Signature'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<Wallet>(
              value: selectedWallet.value,
              items: wallets.value
                      ?.map((wallet) => DropdownMenuItem(value: wallet, child: Text(wallet.name!)))
                      .toList() ??
                  [],
              onChanged: (wallet) => selectedWallet.value = wallet,
            ),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter the message to sign',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      ref.invalidate(generateSignatureNotifierProvider);
                      ref.read(generateSignatureNotifierProvider.notifier).generateSignature(
                          messageController.text, selectedWallet.value?.id ?? '');
                    },
              child: const Text('Generate Signature'),
            ),
            if (generateSignatureState.isLoading) const CircularProgressIndicator(),
            if (generateSignatureState.hasError) Text(generateSignatureState.error.toString()),
            if (generateSignatureState.hasValue) Text(generateSignatureState.value.toString()),
          ],
        ),
      ),
    );
  }
}
