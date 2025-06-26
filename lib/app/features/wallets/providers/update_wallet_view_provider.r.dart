// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_wallet_view_provider.r.g.dart';

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
