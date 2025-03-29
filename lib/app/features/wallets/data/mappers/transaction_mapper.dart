// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart' as db;
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_details.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

// TODO: As for now it supports only coins
class CoinTransactionsMapper {
  db.Transaction fromTransactionDetails({
    required TransactionDetails details,
    String? balanceBeforeTransactions,
  }) {
    final coinAssetData = details.assetData as CoinAssetToSendData;

    return db.Transaction(
      id: details.id,
      txHash: details.txHash,
      type: details.type.value,
      networkId: details.network.id,
      coinId: coinAssetData.selectedOption!.coin.id,
      nativeCoinId: details.nativeCoin.id,
      senderWalletAddress: details.receiverAddress,
      receiverWalletAddress: details.senderAddress,
      userPubkey: details.receiverPubkey,
      transferredAmount: coinAssetData.rawAmount,
      transferredAmountUsd: coinAssetData.amountUSD,
      balanceBeforeTransfer: balanceBeforeTransactions,
      status: details.status.toJson(),
      dateConfirmed: details.dateConfirmed,
    );
  }

  List<db.Transaction> fromEntityToDB(
    Iterable<WalletAssetEntity> transactions,
    Iterable<String> userWallets,
    Iterable<CoinData> coins,
  ) =>
      transactions.map((entity) {
        final content = entity.data.content;
        final nativeCoin = coins.firstWhereOrNull(
          (coin) => coin.contractAddress.isEmpty && coin.network.id == entity.data.networkId,
        );
        final coin = entity.data.assetClass.toLowerCase() == 'native'
            ? nativeCoin
            : coins.firstWhereOrNull(
                (coin) => coin.contractAddress == entity.data.assetAddress,
              );

        return db.Transaction(
          type: userWallets.contains(content.from)
              ? TransactionType.send.value
              : TransactionType.receive.value,
          txHash: content.txHash,
          // assetId: , // Here should be nftId in case of nfts
          networkId: entity.data.networkId,
          coinId: coin?.id,
          nativeCoinId: nativeCoin?.id,
          senderWalletAddress: content.from,
          receiverWalletAddress: content.to,
          createdAt: entity.createdAt,
          userPubkey: entity.data.pubkey,
          transferredAmount: content.amount,
          transferredAmountUsd: double.tryParse(content.amountUsd ?? '0'),
          balanceBeforeTransfer: entity.data.content.balance,
        );
      }).toList();

  List<db.Transaction> fromDomainToDB(
    Iterable<TransactionData> transactions,
  ) =>
      transactions.map((transaction) {
        final coinTransactionAsset = transaction.cryptoAsset.as<CoinTransactionAsset>();

        return db.Transaction(
          type: transaction.type.value,
          txHash: transaction.txHash,
          id: transaction.id,
          fee: transaction.fee,
          dateConfirmed: transaction.dateConfirmed,
          // assetId: , // Here should be nftId in case of nfts
          networkId: transaction.network.id,
          status: transaction.status?.toJson(),
          coinId: coinTransactionAsset?.coin.id,
          nativeCoinId: transaction.nativeCoin.id,
          senderWalletAddress: transaction.senderWalletAddress,
          receiverWalletAddress: transaction.receiverWalletAddress,
          createdAt: transaction.createdAt,
          userPubkey: transaction.userPubkey,
          transferredAmount: coinTransactionAsset?.rawAmount,
          transferredAmountUsd: coinTransactionAsset?.amountUSD,
          balanceBeforeTransfer: coinTransactionAsset?.balanceBeforeTransaction,
        );
      }).toList();
}
