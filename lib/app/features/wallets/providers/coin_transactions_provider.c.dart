// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/transactions_history_notifier_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transactions_provider.c.g.dart';

// TODO: Probably, should be moved to the domain layer.
@riverpod
class CoinTransactionsNotifier extends _$CoinTransactionsNotifier {
  // Used completer here to keep loading state until the whole history will be loaded
  final _completer = Completer<List<CoinTransactionData>>();

  @override
  Future<List<CoinTransactionData>> build({required String symbolGroup}) async {
    final transactions = ref.watch(transactionsHistoryNotifierProvider);

    // Keep loading state if transactions are not loaded
    if (transactions == null) return _completer.future;

    final walletView = await ref.watch(currentWalletViewDataProvider.future);
    final cryptoWallets = await ref.watch(connectedCryptoWalletsProvider.future);
    final encryptedMessageService = await ref.read(encryptedMessageServiceProvider.future);
    final coinsGroup = walletView.coinGroups.firstWhereOrNull((e) => e.symbolGroup == symbolGroup);

    if (coinsGroup != null) {
      final wallets = Map.fromEntries(
        cryptoWallets.where((wallet) => wallet.address != null).map((e) => MapEntry(e.address!, e)),
      );

      // All transactions with unknown network or coin (which is not in the wallet view now) will be filtered out
      final filtered = Map.fromEntries(
        transactions.map((entity) {
          final coinData = coinsGroup.coins.firstWhereOrNull((coinInWallet) {
            final coin = coinInWallet.coin;
            final isTheSameAddress =
                coin.contractAddress.isNotEmpty && coin.contractAddress == entity.data.assetAddress;
            final isNativeCoinsOfTheSameNetwork = coin.isNative &&
                entity.data.assetAddress.isEmpty &&
                coin.network.id == entity.data.networkId;

            return isTheSameAddress || isNativeCoinsOfTheSameNetwork;
          });

          return coinData == null ? null : MapEntry(entity, coinData);
        }).nonNulls,
      );

      final converted = await Future.wait(
        // TODO: Filter out nfts from history
        filtered.keys.map((entity) async {
          final coin = filtered[entity]!;
          late final WalletAssetContent walletAssetContent;

          try {
            final decrypted = await encryptedMessageService.decryptMessage(entity.data.content);
            final decoded = jsonDecode(decrypted) as Map<String, dynamic>;
            walletAssetContent = WalletAssetContent.fromJson(decoded);
          } catch (ex) {
            Logger.error(
              'Failed to decrypt content. Remove transaction from history.\n'
              'Entity id is ${entity.id}. \nException: $ex',
            );
            return null;
          }

          final amount =
              (double.tryParse(walletAssetContent.amount ?? '') ?? 0) / pow(10, coin.coin.decimals);

          return CoinTransactionData(
            network: coin.coin.network,
            timestamp: entity.createdAt.millisecondsSinceEpoch,
            transactionType: wallets.keys.contains(walletAssetContent.from)
                ? TransactionType.send
                : TransactionType.receive,
            coinAmount: amount,
            usdAmount: double.tryParse(walletAssetContent.amountUsd ?? '') ?? 0,
          );
        }),
      );
      final result = converted.nonNulls.toList();
      _completer.complete(result);
    }

    return _completer.future;
  }
}
