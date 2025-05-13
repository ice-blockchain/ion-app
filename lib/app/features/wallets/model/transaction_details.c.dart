// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';

part 'transaction_details.c.freezed.dart';

@freezed
class TransactionDetails with _$TransactionDetails {
  const factory TransactionDetails({
    required String txHash,
    required NetworkData network,
    required TransactionType type,
    required CryptoAssetToSendData assetData,
    required TransactionStatus status,
    required CoinData nativeCoin,
    required String walletViewId,
    required String? senderAddress,
    required String? receiverAddress,
    required String? walletViewName,
    required String? id,
    required String? participantPubkey,
    required DateTime? dateRequested,
    required DateTime? dateConfirmed,
    required DateTime? dateBroadcasted,
    required NetworkFeeOption? networkFeeOption,
  }) = _TransactionDetails;

  factory TransactionDetails.fromTransactionData(
    TransactionData transaction, {
    required CoinsGroup coinsGroup,
    String? walletViewName,
  }) {
    final feeAmount = transaction.fee != null
        ? parseCryptoAmount(transaction.fee!, transaction.nativeCoin.decimals)
        : null;
    return TransactionDetails(
      id: transaction.id,
      txHash: transaction.txHash,
      network: transaction.network,
      walletViewId: transaction.walletViewId,
      type: transaction.type,
      assetData: transaction.cryptoAsset.map(
        coin: (coin) => CryptoAssetToSendData.coin(
          coinsGroup: coinsGroup,
          amount: coin.amount,
          rawAmount: coin.rawAmount,
          amountUSD: coin.amountUSD,
        ),
        nft: (nft) => CryptoAssetToSendData.nft(nft: nft.nft),
      ),
      walletViewName: walletViewName,
      senderAddress: transaction.senderWalletAddress,
      receiverAddress: transaction.receiverWalletAddress,
      participantPubkey: transaction.userPubkey,
      status: transaction.status,
      dateRequested: transaction.dateRequested,
      dateConfirmed: transaction.dateConfirmed,
      nativeCoin: transaction.nativeCoin,
      networkFeeOption: feeAmount != null
          ? NetworkFeeOption(
              amount: feeAmount,
              symbol: transaction.nativeCoin.abbreviation,
              priceUSD: feeAmount * transaction.nativeCoin.priceUSD,
              type: null,
            )
          : null,
      dateBroadcasted: null,
    );
  }

  const TransactionDetails._();

  String get transactionExplorerUrl => network.getExplorerUrl(txHash);
}
