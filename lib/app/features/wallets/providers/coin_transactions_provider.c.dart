// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/transactions_history_notifier_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transactions_provider.c.g.dart';

typedef CoinTransactionsState = ({
  bool hasMore,
  CoinInWalletData coin,
  List<CoinTransactionData> transactions,
});

// TODO: Should be moved to the domain layer.
@riverpod
class CoinTransactionsNotifier extends _$CoinTransactionsNotifier {
  // TODO: Probably, we should load more items auto, if after converting there are not enough to display full page
  static const pageSize = 20;

  final _allItems = <CoinTransactionData>{};

  // Used completer here to keep loading state until the whole history will be loaded
  var _completer = Completer<CoinTransactionsState>();

  @override
  Future<CoinTransactionsState> build({
    required String symbolGroup,
    required NetworkData network,
  }) async {
    final walletView = ref.watch(currentWalletViewDataProvider).valueOrNull;
    final cryptoWallets = ref.watch(connectedCryptoWalletsProvider).valueOrNull;
    final encryptedMessageService = ref.watch(encryptedMessageServiceProvider).valueOrNull;

    if (walletView == null || cryptoWallets == null || encryptedMessageService == null) {
      return _completer.future;
    }

    final coinsGroup = walletView.coinGroups.firstWhereOrNull((e) => e.symbolGroup == symbolGroup);
    final coin = coinsGroup?.coins.firstWhereOrNull((coin) => coin.coin.network == network);

    if (coinsGroup == null || coin == null) {
      return _completer.future;
    }

    final transactionsValue = ref.watch(
      transactionsHistoryNotifierProvider(coin: coin, pageSize: pageSize),
    );

    // Keep loading state if transactions are not loaded
    if (transactionsValue == null) {
      return _completer.future;
    }

    final wallets = Map.fromEntries(
      cryptoWallets.where((wallet) => wallet.address != null).map((e) => MapEntry(e.address!, e)),
    );

    final (:transactions, :hasMore, :dataSource) = transactionsValue;
    final converted = await Future.wait(
      transactions.map((entity) async {
        final amount =
            (double.tryParse(entity.data.content.amount ?? '') ?? 0) / pow(10, coin.coin.decimals);

        return CoinTransactionData(
          network: coin.coin.network,
          timestamp: entity.createdAt.millisecondsSinceEpoch,
          transactionType: wallets.keys.contains(entity.data.content.from)
              ? TransactionType.send
              : TransactionType.receive,
          coinAmount: amount,
          usdAmount: double.tryParse(entity.data.content.amountUsd ?? '') ?? 0,
        );
      }),
    );
    final result = converted.nonNulls;

    Logger.info(
      'Loaded ${transactions.length} transactions. '
      '${result.length} converted to the correct format. The rest were missed',
    );

    _allItems.addAll(result);

    if (!_completer.isCompleted) {
      _completer.complete(
        (
          transactions: _allItems.toList(),
          hasMore: hasMore,
          coin: coin,
        ),
      );
    }

    return _completer.future;
  }

  Future<void> loadMore() async {
    final value = state.value;
    if (value != null) {
      final (:transactions, :hasMore, :coin) = value;
      if (hasMore) {
        _completer = Completer();
        return ref
            .read(transactionsHistoryNotifierProvider(coin: coin, pageSize: pageSize).notifier)
            .loadMore();
      }
    }
  }
}
