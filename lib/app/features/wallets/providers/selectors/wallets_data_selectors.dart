import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_selectors.g.dart';

@riverpod
String walletId(WalletIdRef ref) {
  final selectedWalletId = ref.watch(selectedWalletIdNotifierProvider);
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) {
        if (selectedWalletId != null && walletsData.containsKey(selectedWalletId)) {
          return selectedWalletId;
        }
        final idsList = walletsData.keys.toList();
        return idsList.isEmpty ? '' : idsList[0];
      },
    ),
  );
}

@riverpod
List<WalletData> walletsData(WalletsDataRef ref) {
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) => walletsData.values.toList(),
    ),
  );
}

@riverpod
double walletBalance(WalletBalanceRef ref) {
  final walletId = ref.watch(walletIdProvider);
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) => walletsData[walletId]?.balance ?? 0.0,
    ),
  );
}

@riverpod
String walletName(WalletNameRef ref) {
  final walletId = ref.watch(walletIdProvider);
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) => walletsData[walletId]?.name ?? '',
    ),
  );
}

@riverpod
String walletIcon(WalletIconRef ref) {
  final walletId = ref.watch(walletIdProvider);
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) => walletsData[walletId]?.icon ?? '',
    ),
  );
}
