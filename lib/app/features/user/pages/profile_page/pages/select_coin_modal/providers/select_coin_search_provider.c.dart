// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/filtered_wallet_coins_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_coin_search_provider.c.g.dart';

@riverpod
class SelectCoinSearchQuery extends _$SelectCoinSearchQuery {
  @override
  String build() {
    return '';
  }

  set query(String query) {
    state = query;
  }
}

@riverpod
Future<List<CoinsGroup>> searchedWalletCoins(Ref ref) async {
  final query = ref.watch(selectCoinSearchQueryProvider);
  final coinsResult = await ref.watch(filteredWalletCoinsProvider.future);

  return coinsResult
      .where(
        (coin) =>
            coin.name.toLowerCase().contains(query.toLowerCase()) ||
            coin.abbreviation.toLowerCase().contains(query.toLowerCase()) ||
            coin.symbolGroup.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
}
