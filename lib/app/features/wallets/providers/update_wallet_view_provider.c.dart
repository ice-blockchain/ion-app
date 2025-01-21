// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_wallet_view_provider.c.g.dart';

@riverpod
class UpdateWalletViewNotifier extends _$UpdateWalletViewNotifier {
  @override
  Future<void> build() async {
    state = const AsyncData(null);
  }

  Future<void> updateWalletView({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    if ((updatedName == null && updatedCoinsList == null) || state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final identity = await ref.read(ionIdentityClientProvider.future);

      final request = updatedCoinsList == null
          ? _buildRequestFromWalletView(walletView, updatedName: updatedName)
          : (await _buildRequestFromCoinsList(
              updatedCoinsList,
              identity: identity,
              name: updatedName ?? walletView.name,
            ));

      final updatedWallet =
          await identity.wallets.updateWalletView(walletView.id, request);
      await ref
          .read(userWalletViewsNotifierProvider.notifier)
          .refreshWalletView(updatedWallet);
    });
  }

  CreateUpdateWalletViewRequest _buildRequestFromWalletView(
    WalletViewData walletView, {
    String? updatedName,
  }) {
    final symbolGroups = <String>{};
    final walletViewItems = <CreateUpdateWalletViewItem>[];

    for (final coinInWallet in walletView.coins) {
      final coin = coinInWallet.coin;

      symbolGroups.add(coin.symbolGroup);
      walletViewItems.add(
        CreateUpdateWalletViewItem(
          coinId: coin.id,
          walletId: coinInWallet.walletId,
        ),
      );
    }

    return CreateUpdateWalletViewRequest(
      items: walletViewItems,
      symbolGroups: symbolGroups.toList(),
      name: updatedName ?? walletView.name,
    );
  }

  Future<CreateUpdateWalletViewRequest> _buildRequestFromCoinsList(
    List<CoinData> updatedCoinsList, {
    required IONIdentityClient identity,
    required String name,
  }) async {
    final symbolGroups = <String>{};
    final walletViewItems = <CreateUpdateWalletViewItem>[];

    final userWallets = await identity.wallets.getWallets().then((result) {
      return {for (final wallet in result) wallet.network: wallet};
    });

    for (final coin in updatedCoinsList) {
      symbolGroups.add(coin.symbolGroup);
      walletViewItems.add(
        CreateUpdateWalletViewItem(
          coinId: coin.id,
          walletId: userWallets[coin.network]?.id,
        ),
      );
    }

    return CreateUpdateWalletViewRequest(
      items: walletViewItems,
      symbolGroups: symbolGroups.toList(),
      name: name,
    );
  }
}
