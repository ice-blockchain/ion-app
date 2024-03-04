import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletsDataNotifier extends _$WalletsDataNotifier {
  @override
  Map<String, WalletData> build() {
    final Map<String, WalletData> userAccounts = <String, WalletData>{};
    for (final WalletData walletData in mockedWalletDataArray) {
      userAccounts.putIfAbsent(walletData.id, () => walletData);
    }

    return Map<String, WalletData>.unmodifiable(userAccounts);
  }

  set userData(WalletData newData) {
    final Map<String, WalletData> newState = Map<String, WalletData>.from(state)
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
    state = Map<String, WalletData>.unmodifiable(newState);
  }
}
