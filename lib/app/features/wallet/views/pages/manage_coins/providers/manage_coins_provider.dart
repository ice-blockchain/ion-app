import 'package:ice/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/providers/mock_data/manage_coins_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.g.dart';

@riverpod
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  AsyncValue<List<ManageCoinData>> build() {
    return AsyncData<List<ManageCoinData>>(
      List<ManageCoinData>.unmodifiable(<ManageCoinData>[]),
    );
  }

  Future<void> fetch({
    required String searchValue,
  }) async {
    state = const AsyncLoading<List<ManageCoinData>>().copyWithPrevious(state);

    // to emulate loading state
    await Future<void>.delayed(const Duration(seconds: 1));

    final lSearchValue = searchValue.trim().toLowerCase();

    state = AsyncData<List<ManageCoinData>>(
      List<ManageCoinData>.unmodifiable(
        mockedManageCoinsDataArray.where(
          (ManageCoinData data) => data.coinData.name.toLowerCase().contains(lSearchValue),
        ),
      ),
    );
  }

  void switchCoin({
    required String coinId,
  }) {
    final list = state.value;
    if (list != null) {
      state = AsyncData<List<ManageCoinData>>(
        List<ManageCoinData>.unmodifiable(
          List<ManageCoinData>.from(list).map(
            (ManageCoinData data) {
              if (data.coinData.abbreviation == coinId) {
                return data.copyWith(isSelected: !data.isSelected);
              }
              return data;
            },
          ),
        ),
      );
    }
  }
}
