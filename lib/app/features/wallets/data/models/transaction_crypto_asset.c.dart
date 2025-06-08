// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/nft_data.c.dart';

part 'transaction_crypto_asset.c.freezed.dart';

@freezed
sealed class TransactionCryptoAsset with _$TransactionCryptoAsset {
  const factory TransactionCryptoAsset.coin({
    required CoinData coin,
    @Default(0.0) double amount,
    @Default(0.0) double amountUSD,
    @Default('0') String rawAmount,
    String? balanceBeforeTransaction,
  }) = CoinTransactionAsset;

  const factory TransactionCryptoAsset.nft({
    required NftData nft,
  }) = NftTransactionAsset;

  const TransactionCryptoAsset._();
}
