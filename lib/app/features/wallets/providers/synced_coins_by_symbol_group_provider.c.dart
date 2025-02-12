import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synced_coins_by_symbol_group_provider.c.g.dart';

@riverpod
Future<List<CoinInWalletData>> syncedCoinsBySymbolGroup(Ref ref, String symbolGroup) async {
  final service = await ref.watch(coinsServiceProvider.future);
  final coins = await service.getSyncedCoinsBySymbolGroup(symbolGroup);
  final walletViewCoins =
      await ref.watch(currentWalletViewDataProvider.future).then((walletView) => walletView.coins);

  final result = <CoinInWalletData>[];
  for (final coin in coins) {
    final fromWallet = walletViewCoins.firstWhereOrNull((e) => e.coin.id == coin.id);
    result.add(fromWallet ?? CoinInWalletData(coin: coin));
  }
  result.sort(CoinsComparator().compareCoins);

  return result;
}
