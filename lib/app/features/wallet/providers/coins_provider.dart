import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.g.dart';

@Riverpod(keepAlive: true)
List<CoinData> coinsData(CoinsDataRef ref) => mockedCoinsDataArray;

@riverpod
CoinData coinById(CoinByIdRef ref, {required String coinId}) {
  final coins = ref.watch(coinsDataProvider);

  return coins.firstWhere((CoinData coin) => coin.abbreviation == coinId);
}

@Riverpod(keepAlive: true)
class CoinsNotifier extends _$CoinsNotifier {
  @override
  Future<List<CoinData>> build() async {
    // Simulate a delay or fetch operation
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Fetch the search value
    final searchValue =
        ref.watch(walletPageNotifierProvider).assetSearchValues[WalletTabType.coins];

    // Filter data based on search value if provided
    if (searchValue != null && searchValue.isNotEmpty) {
      final lSearchValue = searchValue.trim().toLowerCase();
      final filteredData = mockedCoinsDataArray
          .where(
            (CoinData data) => data.name.toLowerCase().contains(lSearchValue),
          )
          .toList();

      // Return the filtered data
      return List<CoinData>.unmodifiable(filteredData);
    }

    // If no search value, return the full list
    return ref.watch(coinsDataProvider);
  }
}
