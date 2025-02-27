// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';

part 'nft_data.c.freezed.dart';

@freezed
class NftData with _$NftData {
  const factory NftData({
    required String collectionName,
    required int identifier,
    required double price,
    required String currency,
    required String iconUrl,
    required String currencyIconUrl,
    required String description,
    required NetworkData network,
    required String tokenStandard,
    required String contractAddress,
    required int rank,
    required String asset,
  }) = _NftData;
}
