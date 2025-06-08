// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synced_coins_by_symbol_group_provider.c.g.dart';

typedef SyncedCoinsCache = Map<String, List<CoinInWalletData>>;

@Riverpod(keepAlive: true)
class SyncedCoinsBySymbolGroupNotifier extends _$SyncedCoinsBySymbolGroupNotifier {
  late final _coinsComparator = CoinsComparator();

  @override
  FutureOr<SyncedCoinsCache> build() async {
    // Reset state when isAuthenticated changes
    await ref.watch(authProvider.selectAsync((state) => state.isAuthenticated));
    // Reset state each time the wallet view changes
    await ref.watch(currentWalletViewIdProvider.future);

    return {};
  }

  /// Retrieves coins for a specific symbol group, using cache when available
  Future<List<CoinInWalletData>> getCoins(String symbolGroup) async {
    final cachedData = state.value?[symbolGroup];
    if (cachedData != null) return cachedData;

    final updatedCoins = await _fetchAndProcessCoins(symbolGroup);
    _updateCache({symbolGroup: updatedCoins});

    return updatedCoins;
  }

  /// Refreshes coin data for specified symbol groups or all cached groups
  Future<void> refresh([List<String>? symbolGroups]) async {
    final currentCache = state.valueOrNull ?? {};
    final groupsToUpdate = symbolGroups ?? currentCache.keys.toList();

    final updates = await Future.wait(
      groupsToUpdate.map((group) async {
        final coins = await _fetchAndProcessCoins(group);
        return MapEntry(group, coins);
      }),
    );

    _updateCache(Map.fromEntries(updates));
  }

  Future<List<CoinInWalletData>> _fetchAndProcessCoins(String symbolGroup) async {
    final service = await ref.read(coinsServiceProvider.future);
    final coins = await service.getSyncedCoinsBySymbolGroup(symbolGroup);
    final walletCoins = await _getWalletViewCoins();

    return _processCoins(coins, walletCoins);
  }

  Future<List<CoinInWalletData>> _getWalletViewCoins() async {
    return ref.read(currentWalletViewDataProvider.future).then((walletView) => walletView.coins);
  }

  List<CoinInWalletData> _processCoins(
    Iterable<CoinData> coins,
    Iterable<CoinInWalletData> walletCoins,
  ) {
    final result = coins.map((coin) {
      final fromWallet = walletCoins.firstWhereOrNull((e) => e.coin.id == coin.id);
      return fromWallet?.copyWith(coin: coin) ?? CoinInWalletData(coin: coin);
    }).toList();

    return result..sort(_coinsComparator.compareCoins);
  }

  void _updateCache(Map<String, List<CoinInWalletData>> updates) {
    state = AsyncValue.data({
      ...state.valueOrNull ?? {},
      ...updates,
    });
  }
}

@riverpod
Future<List<CoinInWalletData>> syncedCoinsBySymbolGroup(
  Ref ref,
  String symbolGroup,
) async {
  final notifier = ref.watch(syncedCoinsBySymbolGroupNotifierProvider.notifier);
  return notifier.getCoins(symbolGroup);
}
