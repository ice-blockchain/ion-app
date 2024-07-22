import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.dart';

List<ManageCoinData> manageCoinsDataSelector(WidgetRef ref) {
  return ref.watch(
    manageCoinsNotifierProvider.select(
      (AsyncValue<List<ManageCoinData>> data) => data.value ?? <ManageCoinData>[],
    ),
  );
}

bool manageCoinsIsLoadingSelector(WidgetRef ref) {
  return ref.watch(
    manageCoinsNotifierProvider.select(
      (AsyncValue<List<ManageCoinData>> data) => data.isLoading,
    ),
  );
}
