// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_wallet_view_provider.c.g.dart';

@riverpod
class UpdateWalletViewNotifier extends _$UpdateWalletViewNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> updateWalletView({
    required WalletViewData walletView,
    required String walletViewName,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      final identity = ionIdentity(username: currentIdentityKeyName);

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
