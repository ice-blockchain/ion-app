import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@riverpod
String currentWalletId(CurrentWalletIdRef ref) {
  final selectedWalletId = ref.watch(selectedWalletIdNotifierProvider);
  final walletsData = ref.watch(walletsDataNotifierProvider);

  if (selectedWalletId != null && walletsData.containsKey(selectedWalletId)) {
    return selectedWalletId;
  }

  final idsList = walletsData.keys.toList();
  return idsList.isEmpty ? '' : idsList[0];
}

@riverpod
WalletData currentWalletData(CurrentWalletDataRef ref) {
  final currentWalletId = ref.watch(currentWalletIdProvider);
  final walletsData = ref.watch(walletsDataNotifierProvider);

  return walletsData[currentWalletId] ?? walletsData.values.first;
}

@riverpod
List<WalletData> walletsList(WalletsListRef ref) {
  return ref.watch(walletsDataNotifierProvider).values.toList();
}

@riverpod
class WalletsDataNotifier extends _$WalletsDataNotifier {
  @override
  Map<String, WalletData> build() {
    return {for (final item in mockedWalletDataArray) item.id: item};
  }

  void updateWallet(WalletData newData) {
    final newState = Map<String, WalletData>.from(state)
      ..update(
        newData.id,
        (WalletData value) => value.copyWith(
          id: newData.id,
          name: newData.name,
          icon: newData.icon,
          balance: newData.balance,
        ),
        ifAbsent: () => newData,
      );
    state = newState;
  }

  void deleteWallet(String walletId) {
    state = Map<String, WalletData>.from(state)..remove(walletId);
  }
}
