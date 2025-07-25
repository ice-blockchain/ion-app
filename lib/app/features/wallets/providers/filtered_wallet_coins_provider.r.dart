// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_coins_provider.r.g.dart';

// TODO: review this provider, it's async, but might be sync; or use "await .future"
@riverpod
Future<List<CoinsGroup>> filteredWalletCoins(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  final selectedCoinsState = ref.watch(currentWalletViewDataProvider);

  return selectedCoinsState.maybeWhen(
    data: (walletView) {
      final groups = walletView.coinGroups;
      return isZeroValueAssetsVisible
          ? groups
          : groups.where((coin) => coin.totalBalanceUSD > 0.00).toList();
    },
    orElse: () => [],
  );
}
