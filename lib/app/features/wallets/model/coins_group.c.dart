// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';

part 'coins_group.c.freezed.dart';

@freezed
class CoinsGroup with _$CoinsGroup {
  const factory CoinsGroup({
    required String name,
    required String iconUrl,
    required String symbolGroup,
    required String abbreviation,
    required List<CoinData> coins,
    @Default(0) double totalAmount,
    @Default(0) double totalBalanceUSD,
  }) = _CoinsGroup;

  factory CoinsGroup.fromCoinsData(Iterable<CoinData> coins){
    final coin = coins.first;
    return CoinsGroup(
      name: coin.name,
      iconUrl: coin.iconUrl,
      symbolGroup: coin.symbolGroup,
      abbreviation: coin.abbreviation,
      coins: coins.toList(),
    );
  }

  const CoinsGroup._();
}
