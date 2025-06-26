// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/coins/models/coin.f.dart';
import 'package:ion_identity_client/src/coins/models/network.f.dart';

part 'coins_response.f.freezed.dart';
part 'coins_response.f.g.dart';

@freezed
class CoinsResponse with _$CoinsResponse {
  const factory CoinsResponse({
    required List<Coin> coins,
    required List<Network> networks,
    required int version,
  }) = _CoinsResponse;

  factory CoinsResponse.fromJson(Map<String, dynamic> json) => _$CoinsResponseFromJson(json);
}
