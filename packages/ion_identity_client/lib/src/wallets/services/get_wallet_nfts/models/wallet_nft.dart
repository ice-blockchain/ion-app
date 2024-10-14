// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_nft.freezed.dart';
part 'wallet_nft.g.dart';

@freezed
class WalletNft with _$WalletNft {
  const factory WalletNft({
    required String kind,
    required String contract,
    required String symbol,
    required String tokenId,
    required String tokenUri,
  }) = _WalletNft;

  factory WalletNft.fromJson(Map<String, dynamic> json) => _$WalletNftFromJson(json);
}
