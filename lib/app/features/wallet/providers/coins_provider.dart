import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.g.dart';

@riverpod
List<CoinData> coinsData(CoinsDataRef ref) => mockedCoinsDataArray;

@riverpod
CoinData coinById(CoinByIdRef ref, {required String coinId}) {
  final coins = ref.watch(coinsDataProvider);

  return coins.firstWhere((CoinData coin) => coin.abbreviation == coinId);
}

@riverpod
Future<List<CoinData>> fetchCoinsData(FetchCoinsDataRef ref, String searchValue) async {
  // to emulate loading state
  await Future<void>.delayed(const Duration(seconds: 1));

  final lSearchValue = searchValue.trim().toLowerCase();
  return Future.value(
    List<CoinData>.unmodifiable(
      mockedCoinsDataArray.where(
        (CoinData data) => data.name.toLowerCase().contains(lSearchValue),
      ),
    ),
  );
}

@Riverpod(keepAlive: true)
class CoinsNotifier extends _$CoinsNotifier {
  @override
  AsyncValue<List<CoinData>> build() {
    return AsyncData<List<CoinData>>(
      List<CoinData>.unmodifiable(<CoinData>[]),
    );
  }

  Future<void> fetch({
    required String walletId,
    required String searchValue,
  }) async {
    state = const AsyncLoading<List<CoinData>>().copyWithPrevious(state);

    // to emulate loading state
    await Future<void>.delayed(const Duration(seconds: 1));

    final lSearchValue = searchValue.trim().toLowerCase();
    final newData = AsyncData<List<CoinData>>(
      List<CoinData>.unmodifiable(
        mockedCoinsDataArray.where(
          (CoinData data) => data.name.toLowerCase().contains(lSearchValue),
        ),
      ),
    );

    if (state.asData?.value != newData) {
      state = newData;
    }
  }
}
