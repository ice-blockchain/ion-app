// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

part 'transaction_details.c.freezed.dart';

@freezed
class TransactionDetails with _$TransactionDetails {
  const factory TransactionDetails({
    required String txHash,
    required String walletId,
    required NetworkData network,
    required TransactionType type,
    required CryptoAssetToSendData assetData,
    required String walletViewName,
    required String senderAddress,
    required String receiverAddress,
    required String? receiverPubkey,
    // TODO: Most likely will be replaced with more flexible model to cover case with receive transactions.
    required NetworkFeeOption? networkFeeOption,
    // TODO: Recheck these fields. We don't have them for the receive transactions.
    required TransactionStatus status,
    required DateTime dateRequested,
    required DateTime? dateConfirmed,
    required DateTime? dateBroadcasted,
    required CoinData nativeCoin,
    String? id,
  }) = _TransactionDetails;

  const TransactionDetails._();

  String get transactionExplorerUrl => network.getExplorerUrl(txHash);
}
