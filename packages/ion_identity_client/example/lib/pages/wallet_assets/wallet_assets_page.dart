import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/wallet_assets/providers/wallet_assets_provider.dart';

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
        child: Text(error.toString()),
      ),
      data: (assets) {
        return assets.when(
          success: (walletAssets) => ListView.builder(
            itemCount: walletAssets.assets.length,
            itemBuilder: (context, index) {
              final asset = walletAssets.assets[index];
              return ListTile(
                title: Text('symbol: ${asset.symbol}'),
                subtitle: Text('balance: ${asset.balance}'),
              );
            },
          ),
          failure: (error) => Center(
            child: Text(error.toString()),
          ),
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text('Wallet Assets for wallet ID: $walletId'),
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
