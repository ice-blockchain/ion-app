// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/domain/coins_mapper.dart';
import 'package:ion/app/features/wallet/data/coins/repository/coins_repository.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_initializer.c.g.dart';

@riverpod
CoinInitializer coinInitializer(Ref ref) {
  return CoinInitializer(ref.watch(coinsRepositoryProvider));
}

class CoinInitializer {
  CoinInitializer(this._coinsRepository);

  final CoinsRepository _coinsRepository;

  Future<void> initialize() async {
    final hasCoins = await _coinsRepository.hasSavedCoins();
    if (hasCoins) return;

    // load coins from assets file
    final coinsJson =
        (await rootBundle.loadString(Assets.ionIdentity.coins).then(jsonDecode)) as List<dynamic>;

    final coinEntities = coinsJson
        .expand(
          (group) =>
              // ignore: avoid_dynamic_calls
              (group['coins'] as List).map((coin) => Coin.fromJson(coin as Map<String, dynamic>)),
        )
        .toList();

    await _coinsRepository.updateCoins(CoinsMapper.fromIONIdentityCoins(coinEntities));
  }
}
