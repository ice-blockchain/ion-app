// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_mapper.dart';
import 'package:ion/app/services/logger/logger.dart';
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
    Logger.log('XXX: CoinInitializer: initializing coins');
    final hasCoins = await _coinsRepository.hasSavedCoins();
    if (hasCoins) return;

    Logger.log('XXX: CoinInitializer: loading coins');
    await _loadCoins();
    Logger.log('XXX: CoinInitializer: loading coins version');
    await _loadCoinsVersion();
  }

  Future<void> _loadCoins() async {
    // load coins from assets file
    Logger.log('XXX: CoinInitializer: loading coins from assets');
    final coinsJson =
        (await rootBundle.loadString(Assets.ionIdentity.coins).then(jsonDecode)) as List<dynamic>;

    Logger.log('XXX: CoinInitializer: mapping coins to coin entities');
    final coinEntities = coinsJson
        .expand(
          (group) =>
              // ignore: avoid_dynamic_calls
              (group['coins'] as List).map((coin) => Coin.fromJson(coin as Map<String, dynamic>)),
        )
        .toList();

    Logger.log('XXX: CoinInitializer: updating coins in repository');
    await _coinsRepository.updateCoins(CoinsMapper().fromDtoToDb(coinEntities));
    Logger.log('XXX: CoinInitializer: coins loaded');
  }

  Future<void> _loadCoinsVersion() async {
    Logger.log('XXX: CoinInitializer: loading coins version from assets');
    final coinsVersion =
        await rootBundle.loadString(Assets.ionIdentity.coinsVersion).then(int.parse);
    Logger.log('XXX: CoinInitializer: updating coins version in repository');
    await _coinsRepository.setCoinsVersion(coinsVersion);
    Logger.log('XXX: CoinInitializer: coins version loaded');
  }
}
