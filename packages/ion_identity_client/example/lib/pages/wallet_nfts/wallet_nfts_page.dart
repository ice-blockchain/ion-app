// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/wallet_nfts/providers/wallet_nfts_provider.r.dart';

class WalletNftsPage extends HookConsumerWidget {
  const WalletNftsPage({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet NFTs'),
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
    final nftsResult = ref.watch(walletNftsProvider(walletId));

    final child = nftsResult.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(_getErrorMessage(context, error)),
      ),
      data: (walletNfts) => _SuccessState(walletNfts: walletNfts),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text('Wallet NFTs for wallet ID: $walletId'),
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

class _SuccessState extends StatelessWidget {
  const _SuccessState({
    required this.walletNfts,
  });

  final WalletNfts walletNfts;

  @override
  Widget build(BuildContext context) {
    if (walletNfts.nfts.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      itemCount: walletNfts.nfts.length,
      itemBuilder: (context, index) {
        final nft = walletNfts.nfts[index];
        return ListTile(
          title: Text('symbol: ${nft.symbol} / kind: ${nft.kind}'),
          subtitle: Text('token id: ${nft.tokenId} / contract: ${nft.contract}'),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No NFTs found'),
    );
  }
}
