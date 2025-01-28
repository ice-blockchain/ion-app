// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_service.c.g.dart';

@riverpod
Future<CoinsService> coinsService(Ref ref) async {
  return CoinsService(
    ref.watch(coinsRepositoryProvider),
  );
}

class CoinsService {
  CoinsService(
    this._coinsRepository,
  );

  final CoinsRepository _coinsRepository;

  Stream<Iterable<CoinData>> watchCoins(Iterable<String>? coinIds) {
    return _coinsRepository.watchCoins(coinIds).map((coins) => coins.map(CoinData.fromDB));
  }
}
