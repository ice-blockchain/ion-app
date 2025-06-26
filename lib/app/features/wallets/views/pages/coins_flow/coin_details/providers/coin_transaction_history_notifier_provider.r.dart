// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_history_state.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.r.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/network_selector_notifier.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transaction_history_notifier_provider.r.g.dart';

@riverpod
class CoinTransactionHistoryNotifier extends _$CoinTransactionHistoryNotifier {
  static const int _pageSize = 20;
  static const String _tag = 'CoinTransactionHistory: ';

  late List<String> _coinWalletAddresses;
  late List<CoinInWalletData> _coins;
  late String _walletViewId;

  List<CoinTransactionData> _history = [];
  NetworkData? _network;
  var _offset = 0;

  @override
  Future<CoinTransactionHistoryState> build({required String symbolGroup}) async {
    _walletViewId = await ref.watch(currentWalletViewIdProvider.future);
    _coins = await ref.watch(syncedCoinsBySymbolGroupProvider(symbolGroup).future);
    _coinWalletAddresses = await ref
        .watch(walletViewCryptoWalletsProvider().future)
        .then((wallets) => wallets.map((w) => w.address).nonNulls.toList());

    _network = ref.watch(
      networkSelectorNotifierProvider(symbolGroup: symbolGroup).select(
        (state) => state?.selected.whenOrNull(network: (network) => network),
      ),
    );

    _reset();

    return _getStateWithNewPage();
  }

  void _reset() {
    Logger.warning('$_tag reset history, since notifier dependencies changed');
    _offset = 0;
    _history = [];
  }

  Future<void> loadMore() async {
    if (state.value?.hasMore ?? false) {
      state = await AsyncValue.guard(_getStateWithNewPage);
    }
  }

  bool _canLoadNextPage() {
    if (_coinWalletAddresses.isEmpty) {
      Logger.warning('$_tag wallet addresses list is empty');
      return false;
    }

    return true;
  }

  Future<CoinTransactionHistoryState> _getStateWithNewPage() async {
    if (!_canLoadNextPage()) {
      return CoinTransactionHistoryState(
        transactions: _history,
        hasMore: false,
        isLoading: false,
      );
    }

    final repository = await ref.read(transactionsRepositoryProvider.future);

    final coinIds = _coins
        .where((coin) => _network == null || coin.coin.network == _network)
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
      walletViewIds: [_walletViewId],
      coinIds: coinIds,
      walletAddresses: _coinWalletAddresses,
    );

    _processTransactions(transactions);
    _logTransactionHistory();

    return CoinTransactionHistoryState(
      isLoading: false,
      transactions: _history,
      hasMore: transactions.length >= _pageSize,
    );
  }

  void _processTransactions(List<TransactionData> transactions) {
    _offset += transactions.length;

    _history.addAll(
      transactions.where(_isValidTransaction).map(
        (t) {
          final asset = t.cryptoAsset.as<CoinTransactionAsset>();
          if (asset == null) {
            Logger.warning('$_tag Unexpected null CoinTransactionAsset for transaction: ${t.id}');
            return null;
          }

          final timestamp = t.dateRequested ?? t.createdAtInRelay ?? t.dateConfirmed;
          if (timestamp == null) {
            Logger.warning('$_tag Unexpected null timestamp for transaction: ${t.id}');
            return null;
          }

          return CoinTransactionData(
            network: t.network,
            transactionType: t.type,
            coinAmount: asset.amount,
            usdAmount: asset.amountUSD,
            timestamp: timestamp.millisecondsSinceEpoch,
            origin: t,
          );
        },
      ).nonNulls,
    );
  }

  bool _isValidTransaction(TransactionData tx) {
    if (tx.cryptoAsset is! CoinTransactionAsset) {
      Logger.warning('$_tag Ignored non-coin transaction: ${tx.txHash}');
      return false;
    }

    final hasTimestamp =
        tx.dateRequested != null || tx.createdAtInRelay != null || tx.dateConfirmed != null;
    if (!hasTimestamp) {
      Logger.warning('$_tag Ignored transaction with missing date: ${tx.txHash}');
      return false;
    }

    if (_history.any((h) => h.origin.txHash == tx.txHash)) {
      Logger.warning('$_tag Ignored duplicate transaction: ${tx.txHash}');
      return false;
    }

    return true;
  }

  void _logTransactionHistory() {
    final historyBuffer = StringBuffer();
    for (final item in _history) {
      final origin = item.origin;
      historyBuffer.writeln(
        'txHash: ${origin.txHash}, walletViewId: ${origin.walletViewId}, status: ${origin.status}, '
        'amount: ${item.coinAmount}, type: ${item.transactionType.value}, id: ${origin.id}, '
        'externalHash: ${origin.externalHash}, native coin: ${origin.nativeCoin?.abbreviation}, '
        'userPubkey: ${origin.userPubkey}, network: ${item.network.id}, '
        'dateRequested: ${origin.dateRequested}, createdAtInRelay: ${origin.createdAtInRelay} '
        'dateConfirmed: ${origin.dateConfirmed}',
      );
    }
    Logger.info(
      '$_tag The next page of the history loaded. The full history information:\n$historyBuffer',
    );
  }
}
