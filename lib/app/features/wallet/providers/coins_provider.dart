// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.g.dart';

@Riverpod(keepAlive: true)
List<CoinData> coinsData(Ref ref) => mockedCoinsDataArray;

@riverpod
CoinData coinById(Ref ref, {required String coinId}) {
  final coins = ref.watch(coinsDataProvider);

  return coins.firstWhere((CoinData coin) => coin.abbreviation == coinId);
}
