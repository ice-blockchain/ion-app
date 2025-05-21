// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/string.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/coins_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/networks_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart' as db;
import 'package:ion/app/features/wallets/data/mappers/transaction_mapper.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_repository.c.g.dart';

typedef TransactionsPage = ({List<TransactionData> transactions, String? nextPageToken});

@Riverpod(keepAlive: true)
Future<TransactionsRepository> transactionsRepository(Ref ref) async => TransactionsRepository(
      ref.watch(coinsDaoProvider),
      await ref.watch(walletsNotifierProvider.future),
      ref.watch(networksDaoProvider),
      ref.watch(transactionsDaoProvider),
      await ref.watch(ionIdentityClientProvider.future),
      CoinTransactionsMapper(),
    );

class TransactionsRepository {
  TransactionsRepository(
    this._coinsDao,
    this._userWallets,
    this._networksDao,
    this._transactionsDao,
    this._ionIdentityClient,
    this._coinMapper,
  ) {
    _loadDeprecatedTransactions();
  }

  final CoinsDao _coinsDao;
  final List<Wallet> _userWallets;
  final NetworksDao _networksDao;
  final TransactionsDao _transactionsDao;
  final IONIdentityClient _ionIdentityClient;
  final CoinTransactionsMapper _coinMapper;
  final Completer<Map<String, TransactionData>> _deprecatedTransactionsCompleter = Completer();

  void _loadDeprecatedTransactions() {
    if (_deprecatedTransactionsCompleter.isCompleted) {
      return;
    }

    _transactionsDao.getTransactions(
      walletViewIds: [TransactionsTable.defaultWalletViewIdForDeprecated],
    ).then((txs) {
      final mapped = Map.fromEntries(
        txs.map((tx) => MapEntry(tx.txHash, tx)),
      );

      if (!_deprecatedTransactionsCompleter.isCompleted) {
        _deprecatedTransactionsCompleter.complete(mapped);
      }

      return mapped;
    });
  }

  Future<DateTime?> getLastCreatedAt() => _transactionsDao.lastCreatedAt();

  Future<DateTime?> firstCreatedAt({DateTime? after}) async {
    return _transactionsDao.getFirstCreatedAt(after: after);
  }

  Future<void> saveTransactionDetails(TransactionDetails details) async {
    final mapped = _coinMapper.fromTransactionDetails(details);
    await _transactionsDao.save([mapped]);
  }

  Future<bool> saveTransactions(List<TransactionData> transactions) async {
    final merged = await _mergeWithDeprecatedTransactions(
      _coinMapper.fromDomainToDB(transactions),
    );

    return _transactionsDao.save(merged);
  }

  Future<void> saveEntities(
    List<WalletAssetEntity> entities,
    List<WalletViewData> walletViews,
  ) async {
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

    final walletViewsToConnectedWallets = walletViews.map((wv) {
      return (
        walletViewId: wv.id,
        wallets: wv.coins
            .map((e) => e.walletId)
            .nonNulls
            .map((id) => _userWallets.firstWhereOrNull((e) => e.id == id))
            .nonNulls
            .toList(),
      );
    });

    final mapped = _coinMapper.fromEntityToDB(
      coins,
      entities,
      walletViewsToConnectedWallets,
    );

    if (mapped.isEmpty) {
      if (entities.isNotEmpty) {
        Logger.error(
          'Failed to map transaction entities to the DB models. Entity ids: \n'
          '${entities.map((e) => e.id).join('\n')}',
        );
      }
      return;
    }

    // Get transactions from the DB, where externalHash equals to the txHash from the entity
    final txsWithEntityHashAsExternal = Map.fromEntries(
      await _transactionsDao
          .getTransactions(externalHashes: mapped.map((e) => e.txHash).toList())
          .then((txs) => txs.map((tx) => MapEntry(tx.externalHash, tx))),
    );

    // If txsWithEntityHashAsExternal is not empty, we need to update transactions from entities
    // to use the correct txHash and externalHash, so the right transactions will be updated in the DB
    final txsToSave = txsWithEntityHashAsExternal.isEmpty
        ? mapped
        : mapped.map((entityTx) {
            // txHash from entity should be equal to the externalHash from the saved transaction
            final savedTx = txsWithEntityHashAsExternal[entityTx.txHash];
            return savedTx == null
                ? entityTx
                : entityTx.copyWith(
                    txHash: savedTx.txHash,
                    externalHash: Value.absentIfNull(savedTx.externalHash),
                  );
          }).toList();

    final mergedWithDeprecated = await _mergeWithDeprecatedTransactions(txsToSave);
    await _transactionsDao.save(mergedWithDeprecated);
  }

  Future<List<db.Transaction>> _mergeWithDeprecatedTransactions(
    List<db.Transaction> incomingTxs,
  ) async {
    final deprecated = await _deprecatedTransactionsCompleter.future;
    if (deprecated.isEmpty) return incomingTxs;

    final updatedTxs = <db.Transaction>[];
    final deprecatedToRemove = <String>[];

    for (final tx in incomingTxs) {
      final deprecatedTx = deprecated[tx.txHash];

      updatedTxs.add(
        deprecatedTx == null
            ? tx
            : tx.copyWith(
                createdAtInRelay: Value.absentIfNull(deprecatedTx.createdAtInRelay),
                userPubkey: Value.absentIfNull(deprecatedTx.userPubkey),
              ),
      );
      if (deprecatedTx != null) {
        deprecatedToRemove.add(tx.txHash);
      }
    }

    if (deprecatedToRemove.isNotEmpty) {
      await _transactionsDao.remove(
        txHashes: deprecatedToRemove,
        walletViewIds: [TransactionsTable.defaultWalletViewIdForDeprecated],
      );
    }

    return updatedTxs;
  }

  Stream<Map<CoinData, List<TransactionData>>> watchBroadcastedTransfersByCoins(
    List<String> coinIds,
  ) =>
      _transactionsDao.watchBroadcastedTransfersByCoins(coinIds);

  Future<List<TransactionData>> getBroadcastedTransfers({String? walletAddress}) =>
      _transactionsDao.getBroadcastedTransfers(walletAddress: walletAddress);

  Future<void> remove({
    Iterable<String> txHashes = const [],
    Iterable<String> walletViewIds = const [],
  }) {
    return _transactionsDao.remove(
      txHashes: txHashes,
      walletViewIds: walletViewIds,
    );
  }

  Future<List<TransactionData>> getTransactions({
    List<String> coinIds = const [],
    List<String> txHashes = const [],
    List<String> walletAddresses = const [],
    List<String> walletViewIds = const [],
    int limit = 20,
    int offset = 0,
    NetworkData? network,
  }) {
    return _transactionsDao.getTransactions(
      walletAddresses: walletAddresses,
      txHashes: txHashes,
      limit: limit,
      offset: offset,
      coinIds: coinIds,
      networkId: network?.id,
      walletViewIds: walletViewIds,
    );
  }

  Future<WalletTransferRequests> loadTransfers(
    String walletId, {
    int? pageSize,
    String? pageToken,
  }) =>
      _ionIdentityClient.wallets.getWalletTransferRequests(
        walletId,
        pageSize: pageSize,
        pageToken: pageToken,
      );

  Future<TransactionsPage> loadCoinTransactions(
    String walletId, {
    required String walletViewId,
    int? pageSize,
    String? pageToken,
  }) async {
    final wallet = _userWallets.firstWhere((e) => e.id == walletId);
    final result = await _ionIdentityClient.wallets.getWalletHistory(
      walletId,
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final network = await _networksDao
        .getById(wallet.network)
        .then((network) => network != null ? NetworkData.fromDB(network) : null);
    final nativeCoin = await _coinsDao.getNativeCoin(wallet.network);

    // Check if we have all required fields to build transaction
    if (wallet.address == null || network == null) {
      return const (nextPageToken: null, transactions: <TransactionData>[]);
    }

    final transactions = await result.items
        .map((transaction) async {
          final contract = transaction.contract ?? '';

          // Try to find coin by symbol, if not native coin
          var coin = contract.isEmpty
              ? nativeCoin
              : await _coinsDao.getByFilters(
                  symbols: [transaction.metadata.asset.symbol],
                  networks: [network.id],
                ).then((result) => result.firstOrNull);

          // Contracts in the db and from ion can be different, so use this type of search as the last try
          coin ??= await _coinsDao.getByFilters(
            symbols: [contract],
            networks: [network.id],
          ).then((result) => result.firstOrNull);

          if (coin == null) {
            Logger.error(
              'Coin not found for transaction ${transaction.txHash}. '
              'Tried symbol: ${transaction.metadata.asset.symbol}, '
              'contract: $contract, network: ${network.id}',
            );
            return null;
          }

          final rawAmount = transaction.value;
          final amount = parseCryptoAmount(rawAmount.emptyOrValue, coin.decimals);
          final amountUSD = amount * coin.priceUSD;
          final type = TransactionType.fromDirection(transaction.direction);
          final from = _resolveTransactionAddress(
            direct: transaction.from,
            alternatives: transaction.froms,
            fallbackAddress: type.isSend ? wallet.address : null,
          );
          final to = _resolveTransactionAddress(
            direct: transaction.to,
            alternatives: transaction.tos,
            fallbackAddress: !type.isSend ? wallet.address : null,
          );

          return TransactionData(
            txHash: transaction.txHash,
            walletViewId: walletViewId,
            externalHash: transaction.externalHash,
            network: network,
            type: type,
            senderWalletAddress: from,
            receiverWalletAddress: to,
            nativeCoin: nativeCoin,
            fee: transaction.fee,
            dateConfirmed: transaction.timestamp,
            status: TransactionStatus.confirmed,
            cryptoAsset: TransactionCryptoAsset.coin(
              coin: coin,
              amount: amount,
              amountUSD: amountUSD,
              rawAmount: rawAmount.emptyOrValue,
            ),
          );
        })
        .wait
        .then((result) => result.toList());
    return (transactions: transactions.nonNulls.toList(), nextPageToken: result.nextPageToken);
  }

  Stream<TransactionData?> watchTransactionByEventId(String eventId) {
    return _transactionsDao.watchTransactionByEventId(eventId);
  }

  String? _resolveTransactionAddress({
    required String? direct,
    required List<String>? alternatives,
    required String? fallbackAddress,
  }) {
    if (direct != null) return direct;
    if (alternatives?.length == 1) return alternatives!.first;
    return fallbackAddress;
  }
}
