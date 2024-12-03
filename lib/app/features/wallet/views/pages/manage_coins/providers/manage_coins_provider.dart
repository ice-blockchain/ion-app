// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/mock_data/manage_coins_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.g.dart';

@Riverpod(keepAlive: true)
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  AsyncValue<Map<String, ManageCoinData>> build() {
    return AsyncData<Map<String, ManageCoinData>>(
      Map<String, ManageCoinData>.fromEntries(
        mockedManageCoinsDataArray.map(
          (coin) => MapEntry(coin.coinData.abbreviation, coin),
        ),
      ),
    );
  }

  void switchCoin({required String coinId}) {
    final currentMap = state.value ?? <String, ManageCoinData>{};

    if (currentMap.containsKey(coinId)) {
      final updatedCoin = currentMap[coinId]!.copyWith(
        isSelected: !currentMap[coinId]!.isSelected,
      );

      state = AsyncData<Map<String, ManageCoinData>>(
        {...currentMap, coinId: updatedCoin},
      );
    }
  }
}

@Riverpod(keepAlive: true)
class FilteredCoinsNotifier extends _$FilteredCoinsNotifier {
  @override
  AsyncValue<List<ManageCoinData>> build({required String searchText}) {
    return const AsyncLoading();
  }

  Future<void> filter({required String searchText}) async {
    state = const AsyncLoading();

    await Future<void>.delayed(const Duration(seconds: 1));

    final allCoinsState = ref.read(manageCoinsNotifierProvider);

    state = allCoinsState.maybeWhen(
      data: (allCoinsMap) {
        final allCoins = allCoinsMap.values.toList();
        final query = searchText.trim().toLowerCase();

        if (query.isEmpty) {
          return AsyncData(allCoins);
        }

        final filteredCoins =
            allCoins.where((coin) => coin.coinData.name.toLowerCase().contains(query)).toList();

        return AsyncData(filteredCoins);
      },
      orElse: () => const AsyncLoading(),
    );
  }
}

@Riverpod(keepAlive: true)
AsyncValue<List<ManageCoinData>> selectedCoins(Ref ref) {
  final allCoinsMap = ref.watch(manageCoinsNotifierProvider).value ?? {};
  final selected = allCoinsMap.values.where((coin) => coin.isSelected).toList();
  return AsyncData<List<ManageCoinData>>(selected);
}

@riverpod
CoinData? mockedCoinById(Ref ref, {required String coinId}) {
  return mockedManageCoinsDataArray
      .firstWhere((coin) => coin.coinData.abbreviation == coinId)
      .coinData;
}
