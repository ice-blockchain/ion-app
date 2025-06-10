// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_status.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_type.dart';

part 'transaction_data.c.freezed.dart';

@freezed
class TransactionData with _$TransactionData {
  const factory TransactionData({
    required String txHash,
    required String walletViewId,
    required NetworkData network,
    required TransactionType type,
    required TransactionCryptoAsset cryptoAsset,
    String? id,
    String? fee,
    String? externalHash,
    CoinData? nativeCoin,
    DateTime? dateConfirmed,
    DateTime? dateRequested,
    DateTime? createdAtInRelay,
    String? senderWalletAddress,
    String? receiverWalletAddress,
    @Default(TransactionStatus.broadcasted) TransactionStatus status,
    String? userPubkey,
  }) = _TransactionData;
}
