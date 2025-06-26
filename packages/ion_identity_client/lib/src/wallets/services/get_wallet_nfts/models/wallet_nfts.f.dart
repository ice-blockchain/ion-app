// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/models/wallet_nft.f.dart';

part 'wallet_nfts.f.freezed.dart';
part 'wallet_nfts.f.g.dart';

@freezed
class WalletNfts with _$WalletNfts {
  const factory WalletNfts({
    required String walletId,
    required String network,
    required List<WalletNft> nfts,
  }) = _WalletNfts;

  factory WalletNfts.fromJson(Map<String, dynamic> json) => _$WalletNftsFromJson(json);
}
