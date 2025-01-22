// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/domain/coins_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_initializer.c.g.dart';

@riverpod
Future<CoinInitializer> coinInitializer(Ref ref) async {
  return CoinInitializer(await ref.watch(coinsServiceProvider.future));
}

class CoinInitializer {
  CoinInitializer(this._coinsService);

  final CoinsService _coinsService;

  Future<void> initialize() async {
    final hasCoins = await _coinsService.hasSavedCoins();
    if (hasCoins) return;

    await _loadCoins();
    await _loadCoinsVersion();
  }

  Future<void> _loadCoins() async {
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

    await _coinsService.saveCoins(coinEntities);
  }

  Future<void> _loadCoinsVersion() async {
    final coinsVersion =
        await rootBundle.loadString(Assets.ionIdentity.coinsVersion).then(int.parse);
    await _coinsService.saveCoinsVersion(coinsVersion);
  }
}
