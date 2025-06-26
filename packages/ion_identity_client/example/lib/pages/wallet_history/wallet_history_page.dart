// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client_example/pages/wallet_history/providers/wallet_history_provider.r.dart';

class WalletHistoryPage extends StatelessWidget {
  const WalletHistoryPage({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet History'),
      ),
      body: _Body(walletId: walletId),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletHistoryResult = ref.watch(walletHistoryProvider(walletId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Wallet History for $walletId'),
        Expanded(
          child: walletHistoryResult.when(
            data: (walletHistory) => Text(walletHistory.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
          ),
        ),
      ],
    );
  }
}
