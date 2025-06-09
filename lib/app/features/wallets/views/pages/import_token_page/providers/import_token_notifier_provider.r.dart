// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/providers/update_wallet_view_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_data_notifier_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_form_notifier_provider.c.dart';
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
      var tokenData = await ref.read(tokenDataNotifierProvider.future);
      if (tokenData == null) return;

      if (!tokenData.isValid) {
        final form = ref.read(tokenFormNotifierProvider);
        if (!form.canBeImported) {
          return;
        }

        tokenData = tokenData.copyWith(
          name: form.symbol!,
          abbreviation: form.symbol!.toUpperCase(),
          decimals: form.decimals!,
        );

        final coinsRepository = ref.read(coinsRepositoryProvider);
        await coinsRepository.updateCoins([tokenData.toDB()]);
      }

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
