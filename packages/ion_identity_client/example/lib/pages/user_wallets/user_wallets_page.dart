// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_client_example/pages/user_wallets/providers/user_wallets_provider.dart';
import 'package:ion_client_example/pages/wallet_assets/wallet_assets_page.dart';
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

    final expandedWallets = useState(<int, bool>{});

    final walletsResult = ref.watch(userWalletsProvider(username));
    if (walletsResult.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (walletsResult.hasError) {
      return Center(
        child: Text(walletsResult.error.toString()),
      );
    }

    final wallets = walletsResult.requireValue;

    return switch (wallets) {
      ListWalletsSuccess(:final wallets) => SingleChildScrollView(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WalletAssetsPage(walletId: wallet.id),
                              ),
                            );
                          },
                          child: const Text('Assets'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      _ => Center(
          child: Text(walletsResult.error.toString()),
        ),
    };
  }
}