import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    // TODO: Implement wallet assets provider
    // final assetsResult = ref.watch(walletAssetsProvider(walletId));

    // Stub implementation
    return Center(
      child: Text('Wallet Assets for wallet ID: $walletId'),
    );

    // TODO: Implement proper UI with loading, error, and success states
    // if (assetsResult.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (assetsResult.hasError) {
    //   return Center(
    //     child: SelectableText.rich(
    //       TextSpan(
    //         text: 'Error: ',
    //         style: TextStyle(color: Colors.red),
    //         children: [
    //           TextSpan(text: assetsResult.error.toString()),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // final assets = assetsResult.requireValue;
    // return ListView.builder(
    //   itemCount: assets.length,
    //   itemBuilder: (context, index) {
    //     final asset = assets[index];
    //     return ListTile(
    //       title: Text(asset.name),
    //       subtitle: Text('Balance: ${asset.balance}'),
    //     );
    //   },
    // );
  }
}
