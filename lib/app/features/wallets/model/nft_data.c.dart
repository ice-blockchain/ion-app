// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_data.c.freezed.dart';

@freezed
class NftData with _$NftData {
  const factory NftData({
    required String kind,
    required String contract,
    required String symbol,
    required String tokenId,
    required String tokenUri,
    required String network,
  }) = _NftData;
}
