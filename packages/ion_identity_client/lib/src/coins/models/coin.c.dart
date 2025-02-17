// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/network/duration_converter.dart';

part 'coin.c.freezed.dart';
part 'coin.c.g.dart';

@freezed
class Coin with _$Coin {
  factory Coin({
    required String contractAddress,
    required int decimals,
    required String iconURL,
    required String id,
    required String name,
    required String network,
    required double priceUSD,
    required String symbol,
    required String symbolGroup,
    @DurationConverter() required Duration syncFrequency,
  }) = _Coin;

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}
