// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/network_selector_notifier.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transaction_history_notifier_provider.c.g.dart';

typedef CoinTransactionHistoryState = ({
  List<CoinTransactionData>? transactions,
  bool hasMore,
});

@riverpod
class CoinTransactionHistoryNotifier extends _$CoinTransactionHistoryNotifier {
  static const int _pageSize = 20;
  static const String _tag = 'CoinTransactionHistory: ';

  final List<CoinTransactionData> _history = [];

  List<String>? _coinWalletAddresses;
  List<CoinInWalletData>? _coins;
  String? _walletViewId;
  NetworkData? _network;
  var _offset = 0;

  @override
  CoinTransactionHistoryState? build({required String symbolGroup}) {
    _coinWalletAddresses = ref
        .watch(walletViewCryptoWalletsProvider())
        .valueOrNull
        ?.map((w) => w.address)
        .nonNulls
        .toList();

    _walletViewId = ref.watch(currentWalletViewIdProvider).valueOrNull;
    _network = ref.watch(
      networkSelectorNotifierProvider(symbolGroup: symbolGroup).select(
        (state) => state?.selected.whenOrNull(network: (network) => network),
      ),
    );
    _coins = ref.watch(syncedCoinsBySymbolGroupProvider(symbolGroup)).valueOrNull;

    _reset();
    Logger.info(
      '$_tag Build with the next params: symbolGroup: $symbolGroup, '
      'network: ${_network?.id}, walletViewId: $_walletViewId, '
      'coins: ${_coins?.map((c) => '(${c.coin.abbreviation} in ${c.coin.network.id})').toList()}, '
      'coinWalletAddresses: $_coinWalletAddresses',
    );
    if (_coins != null &&
        _coinWalletAddresses != null &&
        _coinWalletAddresses!.isNotEmpty &&
        _walletViewId != null) {
      _loadNextPage();
    }

    return null;
  }

  void _reset() {
    _history.clear();
    _offset = 0;
  }

  Future<void> reload() async {
    state = null;

    final service = await ref.read(syncTransactionsServiceProvider.future);
    await service.sync();

    _reset();
    await _loadNextPage();
  }

  Future<void> loadMore() async {
    if (state?.hasMore ?? false) {
      await _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    final repository = await ref.read(transactionsRepositoryProvider.future);

    final coinIds = _coins
        ?.where((coin) {
          final result = _network == null || coin.coin.network == _network;
          return result;
        })
        .map((c) => c.coin.id)
        .toList();

    Logger.info(
      '$_tag Load the next page of the history with the next params: '
      'offset: $_offset, network: ${_network?.id}, walletViewId: $_walletViewId, coinIds: $coinIds, '
      'coinWalletAddresses: $_coinWalletAddresses',
    );

    final transactions = await repository.getTransactions(
      offset: _offset,
      network: _network,
      walletViewIds: [_walletViewId!],
      coinIds: coinIds ?? [],
      walletAddresses: _coinWalletAddresses ?? [],
    );
    final filtered = transactions.where((t) {
      final date = t.dateRequested ?? t.createdAtInRelay ?? t.dateConfirmed;
      return t.cryptoAsset is CoinTransactionAsset && date != null;
    });
    _offset += transactions.length;

    _history.addAll(
      filtered.map(
        (t) {
          final asset = t.cryptoAsset.as<CoinTransactionAsset>()!;
          return CoinTransactionData(
            network: t.network,
            transactionType: t.type,
            coinAmount: asset.amount,
            usdAmount: asset.amountUSD,
            timestamp:
                (t.dateRequested ?? t.createdAtInRelay ?? t.dateConfirmed!).millisecondsSinceEpoch,
            origin: t,
          );
        },
      ),
    );

    final historyBuffer = StringBuffer();
    for (final item in _history) {
      final origin = item.origin;
      historyBuffer.writeln(
        'txHash: ${origin.txHash}, walletViewId: ${origin.walletViewId}, status: ${origin.status}, '
        'amount: ${item.coinAmount}, type: ${item.transactionType.value}, id: ${origin.id}, '
        'externalHash: ${origin.externalHash}, native coin: ${origin.nativeCoin?.abbreviation}, '
        'userPubkey: ${origin.userPubkey}, network: ${item.network.id}, '
        'dateRequested: ${origin.dateRequested}, createdAtInRelay: ${origin.createdAtInRelay}',
      );
    }
    Logger.info(
      '$_tag The next page of the history loaded. The full history information:\n$historyBuffer',
    );

    state = (
      transactions: _history,
      hasMore: transactions.length >= _pageSize,
    );
  }
}
