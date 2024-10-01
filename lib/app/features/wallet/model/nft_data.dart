// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_data.freezed.dart';

@Freezed(copyWith: true)
class NftData with _$NftData {
  const factory NftData({
    required String collectionName,
    required int identifier,
    required double price,
    required String currency,
    required String iconUrl,
    required String currencyIconUrl,
    required String description,
    required String network,
    required String tokenStandard,
    required String contractAddress,
    required int rank,
    required String asset,
  }) = _NftData;
}
