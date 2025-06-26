// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/update_wallet_view_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_data_notifier_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'import_token_notifier_provider.r.g.dart';

@riverpod
class ImportTokenNotifier extends _$ImportTokenNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> importToken() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final tokenData = await ref.read(tokenDataNotifierProvider.future);
      if (tokenData == null) return;

      final currentWalletView = await ref.read(currentWalletViewDataProvider.future);
      final walletCoins =
          currentWalletView.coinGroups.expand((e) => e.coins).map((e) => e.coin).toList();

      final updatedCoins = [...walletCoins, tokenData];

      await ref.read(updateWalletViewNotifierProvider.notifier).updateWalletView(
            walletView: currentWalletView,
            updatedCoinsList: updatedCoins,
          );
    });
  }
}
