// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';

class CoinsComparator {
  final CoinPriority _prioritizer = CoinPriority();

  int _compare(
    double balanceA,
    double balanceB,
    String symbolA,
    String symbolB, {
    String? networkA,
    String? networkB,
    bool isNativeA = false,
    bool isNativeB = false,
  }) {
    // 1. Compare by balanceUSD in descending order
    final balanceComparison = balanceB.compareTo(balanceA);
    if (balanceComparison != 0) return balanceComparison;

    // 2. Compare by priority list
    final aPriority = _prioritizer.getPriorityIndex(symbolA.toUpperCase());
    final bPriority = _prioritizer.getPriorityIndex(symbolB.toUpperCase());

    // If both are in priority list, compare their positions
    if (aPriority != -1 && bPriority != -1 && aPriority != bPriority) {
      return aPriority.compareTo(bPriority);
    }

    // If only one is in priority list, it should come first
    if (aPriority != -1 && bPriority == -1) return -1;
    if (bPriority != -1 && aPriority == -1) return 1;

    // 3. Compare by symbol
    final symbolComparison = symbolA.compareTo(symbolB);
    if (symbolComparison != 0) return symbolComparison;

    // 4. If coin is native for network, it should be displayed before other coins,
    // sorted by network
    if (isNativeA && !isNativeB) return -1;
    if (isNativeB && !isNativeA) return 1;

    // 5. If symbols are equal, compare by networks
    if (networkA != null && networkB != null) {
      return networkA.compareTo(networkB);
    }
    // If only one has network, it should come first
    if (networkA != null) return -1;
    if (networkB != null) return 1;

    return 0;
  }

  int compareGroups(CoinsGroup a, CoinsGroup b) {
    return _compare(
      a.totalBalanceUSD,
      b.totalBalanceUSD,
      a.abbreviation,
      b.abbreviation,
    );
  }

  int compareCoins(CoinInWalletData a, CoinInWalletData b) {
    return _compare(
      a.balanceUSD,
      b.balanceUSD,
      a.coin.abbreviation,
      b.coin.abbreviation,
      networkA: a.coin.network.displayName,
      networkB: b.coin.network.displayName,
      isNativeA: a.coin.isNative,
      isNativeB: b.coin.isNative,
    );
  }
}

class CoinPriority {
  final _priorityList = const [
    'ICE', // Ice Open Network
    'BNB', // Binance Coin
    'BTC', // Bitcoin
    'ETH', // Ethereum
    'SOL', // Solana
    'TON', // Toncoin
    'DOGE', // Dogecoin
    'LTC', // Litecoin
    'XLM', // Stellar
    'TRX', // Tron
    'XRP', // Ripple
    'XTZ', // Tezos
    'MATIC', // Polygon
    'DOT', // Polkadot
    'OP', // Optimism
    'ADA', // Cardano
    'ALGO', // Algorand
    'KSM', // Kusama
    'AVAX', // Avalanche
    'KAS', // Kaspa
    'ARB', // Arbitrum
    'S', // Sonic
    'APT', // Aptos
  ];

  int getPriorityIndex(String symbol) {
    return _priorityList.indexOf(symbol);
  }
}
