// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/user_wallet_views/providers/user_wallet_view_provider.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';

class UserWalletViewsPage extends HookConsumerWidget {
  const UserWalletViewsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';

    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Wallet Views'),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';
    final walletViews = ref.watch(userWalletViewsProvider(username));
    return const Text('Wallet Views');
  }
}
