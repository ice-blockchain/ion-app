import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_data_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletDataNotifier extends _$WalletDataNotifier {
  @override
  WalletData build() {
    return mockedWalletDataArray[0];
  }

  set walletData(WalletData newData) {
    state = state.copyWith(
      id: newData.id,
      name: newData.name,
      icon: newData.icon,
      balance: newData.balance,
    );
  }
}
