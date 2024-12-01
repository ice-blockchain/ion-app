// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/mock_data/manage_coins_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.g.dart';

@Riverpod(keepAlive: true)
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  AsyncValue<List<ManageCoinData>> build() {
    return AsyncData<List<ManageCoinData>>(
      List<ManageCoinData>.unmodifiable(mockedManageCoinsDataArray),
    );
  }

  void switchCoin({required String coinId}) {
    final currentList = state.value ?? <ManageCoinData>[];
    state = AsyncData<List<ManageCoinData>>(
      List<ManageCoinData>.unmodifiable(
        currentList.map((coin) {
          if (coin.coinData.abbreviation == coinId) {
            return coin.copyWith(isSelected: !coin.isSelected);
          }
          return coin;
        }),
      ),
    );
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
      data: (allCoins) {
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
AsyncValue<List<ManageCoinData>> allCoins(Ref ref) {
  return ref.watch(manageCoinsNotifierProvider);
}

@Riverpod(keepAlive: true)
AsyncValue<List<ManageCoinData>> selectedCoins(Ref ref) {
  final allCoins = ref.watch(manageCoinsNotifierProvider).value ?? [];
  final selected = allCoins.where((coin) => coin.isSelected).toList();
  return AsyncData<List<ManageCoinData>>(selected);
}
