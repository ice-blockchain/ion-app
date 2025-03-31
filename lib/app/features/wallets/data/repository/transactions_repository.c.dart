// SPDX-License-Identifier: ice License 1.0

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
      CoinTransactionsMapper(),
    );

class TransactionsRepository {
  TransactionsRepository(
    this._coinsDao,
    this._userWallets,
    this._transactionsDao,
    this._ionIdentityClient,
    this._coinMapper,
  );

  final CoinsDao _coinsDao;
  final List<Wallet> _userWallets;
  final TransactionsDao _transactionsDao;
  final IONIdentityClient _ionIdentityClient;
  final CoinTransactionsMapper _coinMapper;

  Future<DateTime?> lastCreatedAt() => _transactionsDao.lastCreatedAt();

  Future<void> saveTransactionDetails({
    required TransactionDetails details,
    String? balanceBeforeTransfer,
  }) async {
    final mapped = _coinMapper.fromTransactionDetails(
      details: details,
      balanceBeforeTransactions: balanceBeforeTransfer,
    );
    await _transactionsDao.save([mapped]);
  }

  Future<void> saveTransactions(List<TransactionData> transactions) =>
      _transactionsDao.save(_coinMapper.fromDomainToDB(transactions));

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

    final mapped = _coinMapper.fromEntityToDB(
      entities,
      _userWallets.map((e) => e.address).nonNulls,
      coins,
    );

    if (mapped.isEmpty) return;

    await _transactionsDao.save(mapped);
  }

  Stream<Map<CoinData, List<TransactionData>>> watchBroadcastedTransfersByCoins(
    List<String> coinIds,
  ) =>
      _transactionsDao.watchBroadcastedTransfersByCoins(coinIds);

  Future<List<TransactionData>> getBroadcastedTransfers() =>
      _transactionsDao.getBroadcastedTransfers();

  Future<TransactionData?> getCoinTransferById({
    required String transferId,
    required String walletId,
  }) async {
    final dto = await _ionIdentityClient.wallets
        .getWalletTransferRequestById(walletId: walletId, transferId: transferId);
    final senderAddress = _userWallets.firstWhereOrNull((e) => e.id == dto.walletId)?.address;
    final symbol = _extractSymbolFromDtoMetadata(dto.metadata);
    final nativeCoin = await _coinsDao.getByFilters(
      networks: [dto.network],
      contractAddresses: [''],
    ).then((result) => result.firstOrNull);
    final transferredCoin = _isNativeKind(dto.requestBody.kind)
        ? nativeCoin
        : symbol == null
            ? null
            : await _coinsDao.getByFilters(
                symbols: [symbol],
                networks: [dto.network],
              ).then((result) => result.firstOrNull);

    if (dto.requestBody is! CoinTransferRequestBody ||
        nativeCoin == null ||
        senderAddress == null ||
        transferredCoin == null) {
      return null;
    }

    final rawAmount = (dto.requestBody as CoinTransferRequestBody).amount;
    final convertedAmount = parseCryptoAmount(rawAmount, transferredCoin.decimals);
    final amountUSD = convertedAmount * transferredCoin.priceUSD;

    return TransactionData(
      id: dto.id,
      network: transferredCoin.network,
      txHash: dto.txHash!,
      type: TransactionType.send,
      senderWalletAddress: senderAddress,
      receiverWalletAddress: dto.requestBody.to,
      nativeCoin: nativeCoin,
      fee: dto.fee,
      status: TransactionStatus.fromJson(dto.status),
      dateConfirmed: dto.dateConfirmed,
      cryptoAsset: CoinTransactionAsset(
        coin: transferredCoin,
        rawAmount: rawAmount,
        amountUSD: amountUSD,
        amount: convertedAmount,
      ),
    );
  }

  bool _isNativeKind(String kind) => kind.toLowerCase().contains('native');

  String? _extractSymbolFromDtoMetadata(Map<String, dynamic>? metadata) {
    final asset = metadata?['asset'];
    if (asset is Map<String, dynamic>) {
      final symbol = asset['symbol'];
      if (symbol is String) return symbol;
    }

    return null;
  }
}
