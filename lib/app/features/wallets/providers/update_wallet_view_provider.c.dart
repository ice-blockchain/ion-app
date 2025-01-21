// SPDX-License-Identifier: ice License 1.0

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
    required String walletViewName,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final identity = await ref.read(ionIdentityClientProvider.future);

      final symbolGroups = <String>{};
      final walletViewItems = <WalletViewItem>[];

      for (final coinInWallet in walletView.coins) {
        final coin = coinInWallet.coin;

        symbolGroups.add(coin.symbolGroup);
        walletViewItems.add(
          WalletViewItem(
            coinId: coin.id,
            walletId: coinInWallet.walletId,
          ),
        );
      }

      await identity.wallets.updateWalletView(
        walletView.id,
        CreateUpdateWalletViewRequest(
          items: walletViewItems,
          symbolGroups: symbolGroups.toList(),
          name: walletViewName,
        ),
      );

      ref.invalidate(currentUserWalletViewsProvider);
    });
  }
}
