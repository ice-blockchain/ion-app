import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_coins_service.c.g.dart';

@riverpod
Future<SearchCoinsService> searchCoinsService(Ref ref) async {
  return SearchCoinsService(
    ref.watch(coinsRepositoryProvider),
  );
}

class SearchCoinsService {
  SearchCoinsService(
    this._coinsRepository,
  );

  final CoinsRepository _coinsRepository;

  Future<List<CoinsGroup>> search(String query) async {
    final coins = await _coinsRepository.searchCoins(query);
    final grouped = coins.groupListsBy((coin) => coin.symbolGroup);
    final result = grouped.keys
        .where((symbolGroup) => grouped[symbolGroup]?.isNotEmpty ?? false)
        .map(
          (symbolGroup) => CoinsGroup.fromCoinsData(
            grouped[symbolGroup]!.map(CoinData.fromDB),
          ),
        );
    return result.toList();
  }
}
