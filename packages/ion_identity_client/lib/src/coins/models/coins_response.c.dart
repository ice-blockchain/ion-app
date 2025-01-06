// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/coins/models/coin.c.dart';

part 'coins_response.c.freezed.dart';
part 'coins_response.c.g.dart';

@freezed
class CoinsResponse with _$CoinsResponse {
  const factory CoinsResponse({
    required List<Coin> coins,
    required int version,
  }) = _CoinsResponse;

  factory CoinsResponse.fromJson(Map<String, dynamic> json) => _$CoinsResponseFromJson(json);
}
