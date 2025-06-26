// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/user_wallets/providers/create_wallet_notifier.r.dart';
import 'package:ion_identity_client_example/pages/user_wallets/providers/user_wallets_provider.r.dart';
import 'package:ion_identity_client_example/pages/wallet_assets/wallet_assets_page.dart';
import 'package:ion_identity_client_example/pages/wallet_generate_signature/wallet_generate_signature_page.dart';
import 'package:ion_identity_client_example/pages/wallet_history/wallet_history_page.dart';
import 'package:ion_identity_client_example/pages/wallet_nfts/wallet_nfts_page.dart';
import 'package:ion_identity_client_example/pages/wallet_transfer_requests/wallet_transfer_requests_page.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';

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
        actions: const [
          _CreateWalletAction(),
          _GenerateSignatureButton(),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _CreateWalletAction extends ConsumerWidget {
  const _CreateWalletAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(createWalletNotifierProvider, (previous, next) {
      if (next.valueOrNull != null) {
        final username = ref.read(currentUsernameNotifierProvider) ?? 'ERROR';
        ref.invalidate(userWalletsProvider(username));
      }
    });

    final createWalletState = ref.watch(createWalletNotifierProvider);
    final isLoading = createWalletState.isLoading;

    return IconButton(
      onPressed: () {
        ref.read(createWalletNotifierProvider.notifier).createWallet('BitcoinTestnet3');
      },
      icon: isLoading ? const CircularProgressIndicator() : const Icon(Icons.add),
    );
  }
}

class _GenerateSignatureButton extends StatelessWidget {
  const _GenerateSignatureButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const WalletGenerateSignaturePage()),
        );
      },
      icon: const Icon(Icons.fingerprint),
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
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _AssetsButton(walletId: wallet.id),
                      const SizedBox(width: 8),
                      _NftsButton(walletId: wallet.id),
                      const SizedBox(width: 8),
                      _HistoryButton(walletId: wallet.id),
                      const SizedBox(width: 8),
                      _TransferRequestsButton(walletId: wallet.id),
                    ],
                  ),
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

class _HistoryButton extends StatelessWidget {
  const _HistoryButton({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('History'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletHistoryPage(walletId: walletId)),
        );
      },
    );
  }
}

class _TransferRequestsButton extends StatelessWidget {
  const _TransferRequestsButton({
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Transfer Requests'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletTransferRequestsPage(walletId: walletId)),
        );
      },
    );
  }
}
