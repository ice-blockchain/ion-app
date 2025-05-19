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
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';

class CoinTransactionsMapper {
  db.Transaction fromTransactionDetails(TransactionDetails details) {
    final coinAssetData = details.assetData as CoinAssetToSendData;

    return db.Transaction(
      id: details.id,
      txHash: details.txHash,
      type: details.type.value,
      walletViewId: details.walletViewId,
      networkId: details.network.id,
      coinId: coinAssetData.selectedOption!.coin.id,
      nativeCoinId: details.nativeCoin?.id,
      senderWalletAddress: details.senderAddress,
      receiverWalletAddress: details.receiverAddress,
      userPubkey: details.participantPubkey,
      transferredAmount: coinAssetData.rawAmount,
      transferredAmountUsd: coinAssetData.amountUSD,
      status: details.status.toJson(),
      dateConfirmed: details.dateConfirmed,
      dateRequested: details.dateRequested,
    );
  }

  List<db.Transaction> fromEntityToDB(
    Iterable<CoinData> coins,
    Iterable<WalletAssetEntity> transactions,
    Iterable<({String walletViewId, List<Wallet> wallets})> walletViewsWithWallets,
  ) {
    final walletAddresses = walletViewsWithWallets
        .expand((wv) => wv.wallets.map((e) => e.address).nonNulls)
        .nonNulls
        .toList();

    return transactions
        .map((entity) {
          final content = entity.data.content;
          final nativeCoin = coins.firstWhereOrNull(
            (coin) => coin.contractAddress.isEmpty && coin.network.id == entity.data.networkId,
          );
          final coin = entity.data.assetClass.toLowerCase() == 'native'
              ? nativeCoin
              : coins.firstWhereOrNull(
                  (coin) => coin.contractAddress == entity.data.assetAddress,
                );

          // Each transaction should be associated with wallet view.
          // Attempt to find wallet view with receiver/sender address.
          final walletViewId = walletViewsWithWallets.firstWhereOrNull((wv) {
            final currentUserWallet = wv.wallets.firstWhereOrNull(
              (w) => w.address != null && (w.address == content.from || w.address == content.to),
            );
            return currentUserWallet != null;
          })?.walletViewId;

          if (walletViewId == null) {
            Logger.error(
              'Transaction ${content.txHash} cannot be associated with any connected wallet.',
            );
            return null;
          }

          return db.Transaction(
            walletViewId: walletViewId,
            type: walletAddresses.contains(content.from)
                ? TransactionType.send.value
                : TransactionType.receive.value,
            txHash: content.txHash,
            // assetId: , // Here should be nftId in case of nfts
            networkId: entity.data.networkId,
            coinId: coin?.id,
            nativeCoinId: nativeCoin?.id,
            senderWalletAddress: content.from,
            receiverWalletAddress: content.to,
            createdAtInRelay: entity.createdAt,
            userPubkey: entity.data.pubkey,
            transferredAmount: content.amount,
            transferredAmountUsd: double.tryParse(content.amountUsd ?? '0'),
            eventId: entity.id,
          );
        })
        .nonNulls
        .toList();
  }

  List<db.Transaction> fromDomainToDB(Iterable<TransactionData> transactions) =>
      transactions.map((transaction) {
        final coinTransactionAsset = transaction.cryptoAsset.as<CoinTransactionAsset>();

        return db.Transaction(
          type: transaction.type.value,
          txHash: transaction.txHash,
          id: transaction.id,
          fee: transaction.fee,
          externalHash: transaction.externalHash,
          walletViewId: transaction.walletViewId,
          dateConfirmed: transaction.dateConfirmed,
          dateRequested: transaction.dateRequested,
          // assetId: , // Here should be nftId in case of nfts
          networkId: transaction.network.id,
          status: transaction.status.toJson(),
          coinId: coinTransactionAsset?.coin.id,
          nativeCoinId: transaction.nativeCoin?.id,
          senderWalletAddress: transaction.senderWalletAddress,
          receiverWalletAddress: transaction.receiverWalletAddress,
          createdAtInRelay: transaction.createdAtInRelay,
          userPubkey: transaction.userPubkey,
          transferredAmount: coinTransactionAsset?.rawAmount,
          transferredAmountUsd: coinTransactionAsset?.amountUSD,
        );
      }).toList();
}
