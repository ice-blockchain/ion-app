// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/data/networks/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_coins_service.c.g.dart';

@riverpod
Future<SearchCoinsService> searchCoinsService(Ref ref) async {
  return SearchCoinsService(
    ref.watch(coinsRepositoryProvider),
    ref.watch(networksRepositoryProvider),
  );
}

class SearchCoinsService {
  SearchCoinsService(
    this._coinsRepository,
    this._networksRepository,
  );

  final CoinsRepository _coinsRepository;
  final NetworksRepository _networksRepository;

  Future<List<CoinsGroup>> search(String query) async {
    final coins = await _coinsRepository.searchCoins(query);
    final networks = await _networksRepository.getAll();

    final grouped = coins.groupListsBy((coin) => coin.symbolGroup);
    final result = grouped.keys.map(
      (symbolGroup) => CoinsGroup.fromCoinsData(
        grouped[symbolGroup]!.map((coin) {
          final network = networks.firstWhere((network) => network.id == coin.network);
          return CoinData.fromDB(coin, network);
        }),
      ),
    );

    return result.toList();
  }
}
