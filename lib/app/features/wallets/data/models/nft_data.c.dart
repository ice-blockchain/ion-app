// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';

part 'nft_data.c.freezed.dart';

typedef NftIdentifier = ({String contract, String tokenId});

@freezed
class NftData with _$NftData {
  const factory NftData({
    required String kind,
    required String contract,
    required String symbol,
    required String tokenId,
    required String tokenUri,
    required String description,
    required String name,
    required String collectionImageUri,
    required NetworkData network,
  }) = _NftData;
  const NftData._();

  NftIdentifier get identifier => (contract: contract, tokenId: tokenId);

  bool matchesIdentifier(NftIdentifier identifier) => this.identifier == identifier;
}
