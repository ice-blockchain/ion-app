// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/user_wallets/providers/user_wallets_provider.dart';
import 'package:ion_client_example/pages/wallet_assets/wallet_assets_page.dart';
import 'package:ion_client_example/pages/wallet_nfts/wallet_nfts_page.dart';
import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_identity_client/ion_client.dart';

class UserWalletsPage extends HookConsumerWidget {
  const UserWalletsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';

    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Wallets'),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';

    final walletsResult = ref.watch(userWalletsProvider(username));

    return walletsResult.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (wallets) => _SuccessState(
        wallets: wallets,
      ),
    );
  }
}

class _SuccessState extends HookWidget {
  const _SuccessState({
    required this.wallets,
  });

  final List<Wallet> wallets;

  @override
  Widget build(BuildContext context) {
    final expandedWallets = useState(<int, bool>{});

    return SingleChildScrollView(
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, isExpanded) {
          expandedWallets.value = {
            ...expandedWallets.value,
            panelIndex: isExpanded,
          };
        },
        children: wallets.indexed.map(
          (e) {
            final index = e.$1;
            final wallet = e.$2;

            return ExpansionPanel(
              isExpanded: expandedWallets.value[index] ?? false,
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text('name: ${wallet.name}'),
                subtitle: Text('network: ${wallet.network}'),
              ),
              body: ListTile(
                title: Row(
                  children: [
                    _AssetsButton(walletId: wallet.id),
                    const SizedBox(width: 8),
                    _NftsButton(walletId: wallet.id),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class _AssetsButton extends StatelessWidget {
  const _AssetsButton({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WalletAssetsPage(walletId: walletId),
          ),
        );
      },
      child: const Text('Assets'),
    );
  }
}

class _NftsButton extends StatelessWidget {
  const _NftsButton({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WalletNftsPage(walletId: walletId),
          ),
        );
      },
      child: const Text('NFTs'),
    );
  }
}
