// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_coins_service.c.g.dart';

@riverpod
SearchCoinsService searchCoinsService(Ref ref) {
  return SearchCoinsService(ref.watch(coinsRepositoryProvider));
}

class SearchCoinsService {
  SearchCoinsService(this._coinsRepository);

  final CoinsRepository _coinsRepository;

  Future<List<CoinsGroup>> search(String query) async {
    final coins = await _coinsRepository.searchCoins(query);
    final grouped = coins.groupListsBy((coin) => coin.symbolGroup);
    final result =
        grouped.keys.map((symbolGroup) => CoinsGroup.fromCoinsData(grouped[symbolGroup]!)).toList();

    return result;
  }
}
