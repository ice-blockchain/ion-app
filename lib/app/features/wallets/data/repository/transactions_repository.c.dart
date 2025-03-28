import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/coins_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_dao.c.dart';
import 'package:ion/app/features/wallets/data/mappers/transaction_mapper.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_repository.c.g.dart';

@Riverpod(keepAlive: true)
Future<TransactionsRepository> transactionsRepository(Ref ref) async => TransactionsRepository(
      ref.watch(coinsDaoProvider),
      await ref.watch(walletsNotifierProvider.future),
      ref.watch(transactionsDaoProvider),
      await ref.watch(ionIdentityClientProvider.future),
    );

class TransactionsRepository {
  TransactionsRepository(
    this._coinsDao,
    this._userWallets,
    this._transactionsDao,
    this._ionIdentityClient,
  );

  final CoinsDao _coinsDao;
  final List<Wallet> _userWallets;
  final TransactionsDao _transactionsDao;
  final IONIdentityClient _ionIdentityClient;

  Future<DateTime?> lastCreatedAt() => _transactionsDao.lastCreatedAt();

  Future<void> saveTransaction({
    required TransactionDetails details,
    String? balanceBeforeTransfer,
  }) async {
    final mapped = CoinTransactionsMapper().fromTransactionDetails(
      details: details,
      balanceBeforeTransactions: balanceBeforeTransfer,
    );
    await _transactionsDao.save([mapped]);
  }

  Future<void> saveEntities(List<WalletAssetEntity> entities) async {
    // Always add empty contract address to get native coin of the network
    final contractFilters = <String>{''};
    final networkFilters = <String>{};

    for (final entity in entities) {
      networkFilters.add(entity.data.networkId);
      contractFilters.add(entity.data.assetAddress);
    }

    final coins = await _coinsDao.getByFilters(
      networks: networkFilters,
      contractAddresses: contractFilters,
    );

    final mapped = CoinTransactionsMapper().fromEntityToDB(
      entities,
      _userWallets.map((e) => e.address).nonNulls,
      coins,
    );

    if (mapped.isEmpty) return;

    await _transactionsDao.save(mapped);
  }

  Stream<Map<CoinData, TransactionData>> watchUnfinishedTransactionsByCoins(
    List<String> coinIds, {
    required DateTime since,
  }) {
    return _transactionsDao.watchUnfinishedTransactionsByCoins(coinIds, since: since);
  }

  Future<void> syncTransfers(
    // Future<({List<TransactionData> transactions, String? nextPageToken})> test(
    String cryptoWalletId, {
    int? pageSize,
    String? paginationToken,
  }) async {
    // _ionIdentityClient.wallets.getWalletTransferRequests(cryptoWalletId)
    final transfersDTO = await _ionIdentityClient.wallets.getWalletTransferRequests(
      cryptoWalletId,
      pageSize: pageSize,
      pageToken: paginationToken,
    );

    final coinSymbols = <String>['']; // Get native tokens for the selected networks too
    final networks = <String>[];

    String? extractSymbol(Map<String, dynamic>? metadata) {
      final asset = metadata?['asset'];
      if (asset is Map<String, dynamic>) {
        final symbol = asset['symbol'];
        if (symbol is String) return symbol;
      }

      return null;
    }

    for (final historyItem in transfersDTO.items) {
      final symbol = extractSymbol(historyItem.metadata);
      if (symbol != null) coinSymbols.add(symbol);
      networks.add(historyItem.network);
    }

    final coins = await _coinsDao.getByFilters(symbols: coinSymbols, networks: networks);

    final converted = transfersDTO.items
        .where((t) => t.requestBody is CoinTransferRequestBody && t.txHash != null)
        .map((transactionDTO) {
      final nativeCoin = coins.firstWhereOrNull(
        (c) => c.contractAddress.isEmpty && c.network.id == transactionDTO.network,
      );
      final symbol = extractSymbol(transactionDTO.metadata);
      final coin = transactionDTO.requestBody.kind.toLowerCase().contains('native')
          ? nativeCoin
          : coins.firstWhereOrNull(
              (c) =>
                  c.abbreviation.toLowerCase() == symbol?.toLowerCase() &&
                  c.network.id == transactionDTO.network,
            );

      if (nativeCoin == null || coin == null) {
        return null;
      }
      final rawAmount = (transactionDTO.requestBody as CoinTransferRequestBody).amount;
      final convertedAmount = parseCryptoAmount(rawAmount, coin.decimals);
      final amountUSD = convertedAmount * coin.priceUSD;
      final senderAddress =
          _userWallets.firstWhereOrNull((e) => e.id == transactionDTO.walletId)?.address;

      if (senderAddress == null) {
        return null;
      }

      return TransactionData(
        network: coin.network,
        txHash: transactionDTO.txHash!,
        type: TransactionType.send,
        senderWalletAddress: senderAddress,
        receiverWalletAddress: transactionDTO.requestBody.to,
        nativeCoin: nativeCoin,
        fee: transactionDTO.fee,
        status: TransactionStatus.fromJson(transactionDTO.status),
        dateConfirmed: transactionDTO.dateConfirmed,
        cryptoAsset: CoinTransactionAsset(
          coin: coin,
          rawAmount: rawAmount,
          amountUSD: amountUSD,
          amount: convertedAmount,
        ),
      );
    })
        // .nonNulls
        .toList();

    // return (transactions: converted, nextPageToken: walletHistoryDTO.nextPageToken);
  }
}
