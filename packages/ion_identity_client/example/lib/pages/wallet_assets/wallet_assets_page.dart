// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/wallet_assets/providers/wallet_assets_provider.c.dart';

class WalletAssetsPage extends HookConsumerWidget {
  const WalletAssetsPage({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Assets'),
      ),
      body: _Body(walletId: walletId),
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsResult = ref.watch(walletAssetsProvider(walletId));

    final child = assetsResult.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(_getErrorMessage(context, error)),
      ),
      data: (walletAssets) => ListView.builder(
        itemCount: walletAssets.assets.length,
        itemBuilder: (context, index) {
          final asset = walletAssets.assets[index];
          return ListTile(
            title: Text('symbol: ${asset.symbol}'),
            subtitle: Text('balance: ${asset.balance}'),
          );
        },
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text('Wallet Assets for wallet ID: $walletId'),
        ),
        Expanded(child: child),
      ],
    );
  }

  String _getErrorMessage(BuildContext context, Object error) {
    return switch (error) {
          IONIdentityException(:final message) => message,
          _ => null,
        } ??
        'Unknown error';
  }
}
