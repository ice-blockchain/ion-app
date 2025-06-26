// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/wallet_assets/providers/make_transfer_notifier.r.dart';
import 'package:ion_identity_client_example/pages/wallet_assets/providers/wallet_assets_provider.r.dart';

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
        actions: [
          _RefreshButton(walletId: walletId),
        ],
      ),
      body: _Body(walletId: walletId),
    );
  }
}

class _RefreshButton extends HookConsumerWidget {
  const _RefreshButton({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(walletAssetsProvider(walletId)).isLoading;

    return IconButton(
      onPressed: () => ref.invalidate(walletAssetsProvider(walletId)),
      icon: isLoading
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.refresh),
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
        itemBuilder: (context, index) => _AssetListItem(
          walletId: walletId,
          asset: walletAssets.assets[index],
        ),
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

class _AssetListItem extends HookConsumerWidget {
  const _AssetListItem({
    required this.walletId,
    required this.asset,
  });

  final String walletId;
  final WalletAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(),
        Text(_getBalance(asset), style: Theme.of(context).textTheme.titleMedium),
        _MakeTransfer(walletId: walletId, asset: asset),
        const Divider(),
      ],
    );
  }

  String _getBalance(WalletAsset asset) {
    return '${double.parse(asset.balance) / pow(10, asset.decimals)} ${asset.symbol}';
  }
}

class _MakeTransfer extends HookConsumerWidget {
  const _MakeTransfer({
    required this.walletId,
    required this.asset,
  });

  final String walletId;
  final WalletAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressController = useTextEditingController();
    final amountController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
          ),
          TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(makeTransferNotifierProvider.notifier).makeTransfer(
                    walletId,
                    addressController.text,
                    amountController.text,
                    asset,
                  );
            },
            child: const Text('Make transfer'),
          ),
        ],
      ),
    );
  }
}
