// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
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
      final notifier = ref.read(walletViewsDataNotifierProvider.notifier);
      await notifier.updateWalletView(
        walletView: walletView,
        updatedName: updatedName,
        updatedCoinsList: updatedCoinsList,
      );
    });
  }
}
