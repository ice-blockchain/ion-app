import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_by_symbol_group_provider.c.g.dart';

@riverpod
Future<List<CoinInWalletData>> coinsBySymbolGroup(
  Ref ref, {
  required String symbolGroup,
}) async {
  final service = await ref.watch(coinsServiceProvider.future);
  final allCoins = await service.getCoinsBySymbolGroup(symbolGroup);
  final walletViewCoins =
      await ref.watch(currentWalletViewDataProvider.future).then((walletView) => walletView.coins);
  final result = <CoinInWalletData>[];

  for (final coin in allCoins) {
    final fromWallet = walletViewCoins.firstWhereOrNull((e) => e.coin.id == coin.id);
    result.add(fromWallet ?? CoinInWalletData(coin: coin));
  }

  result.sort((a, b) {
    // Compare by balanceUSD in descending order
    final balanceComparison = b.balanceUSD.compareTo(a.balanceUSD);
    if (balanceComparison != 0) return balanceComparison;

    // If balanceUSD is equal, sort by network name in ascending order
    return a.coin.network.keyName.compareTo(b.coin.network.keyName);
  });

  await Future<void>.delayed(const Duration(milliseconds: 500));

  return result;
}
