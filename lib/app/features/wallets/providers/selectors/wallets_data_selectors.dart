import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';

String? selectedWalletIdSelector(WidgetRef ref) {
  return ref.watch(
    selectedWalletIdNotifierProvider.select(
      (String? selectedWalletId) => selectedWalletId,
    ),
  );
}

String walletIdSelector(WidgetRef ref) {
  final String? selectedWalletId = selectedWalletIdSelector(ref);
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) {
        if (selectedWalletId != null &&
            walletsData.containsKey(selectedWalletId)) {
          return selectedWalletId;
        }
        final List<String> idsList = walletsData.keys.toList();
        return idsList.isEmpty ? '' : idsList[0];
      },
    ),
  );
}

List<WalletData> walletsDataSelector(WidgetRef ref) {
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) => walletsData.values.toList(),
    ),
  );
}

double walletBalanceSelector({
  required String walletId,
  required WidgetRef ref,
}) {
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) =>
          walletsData[walletId]?.balance ?? 0.0,
    ),
  );
}

String walletNameSelector({
  required String walletId,
  required WidgetRef ref,
}) {
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) =>
          walletsData[walletId]?.name ?? '',
    ),
  );
}

String walletIconSelector({
  required String walletId,
  required WidgetRef ref,
}) {
  return ref.watch(
    walletsDataNotifierProvider.select(
      (Map<String, WalletData> walletsData) =>
          walletsData[walletId]?.icon ?? '',
    ),
  );
}
