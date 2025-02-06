// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_by_filters_provider.c.g.dart';

@riverpod
Future<List<CoinInWalletData>> coinsByFilters(
  Ref ref, {
  String? symbolGroup,
  String? symbol,
}) async {
  assert(
    symbolGroup != null || symbol != null,
    'At least one of symbolGroup or symbol must be provided.',
  );

  final service = await ref.watch(coinsServiceProvider.future);
  final allCoins = await service.getCoinsByFilters(symbolGroup: symbolGroup, symbol: symbol);
  final walletViewCoins =
      await ref.watch(currentWalletViewDataProvider.future).then((walletView) => walletView.coins);
  final result = <CoinInWalletData>[];

  for (final coin in allCoins) {
    final fromWallet = walletViewCoins.firstWhereOrNull((e) => e.coin.id == coin.id);
    result.add(fromWallet ?? CoinInWalletData(coin: coin));
  }
  result.sort(CoinsComparator().compareCoins);

  // Added a small delay to avoid too fast transition from the loading to data display
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return result;
}
