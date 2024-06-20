import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/model/send_coins_form_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_coins_form_provider.g.dart';

@riverpod
class SendCoinsFormController extends _$SendCoinsFormController {
  @override
  SendCoinsFormData build() {
    ref.keepAlive();
    return SendCoinsFormData(
      selectedCoin: mockedCoinsDataArray[0],
      selectedNetwork: NetworkType.eth,
      address: '0x93956a5688078e8f25df21ec0f24fd9fd7baf09545645645745',
      usdtAmount: 350,
      arrivalTime: 15,
    );
  }

  void selectCoin(CoinData coin) => state = state.copyWith(selectedCoin: coin);

  void selectNetwork(NetworkType network) =>
      state = state.copyWith(selectedNetwork: network);

  void updateAddress(String address) =>
      state = state.copyWith(address: address);

  void updateAmount(double amount) =>
      state = state.copyWith(usdtAmount: amount);

  void updateArrivalTime(int arrivalTime) =>
      state = state.copyWith(arrivalTime: arrivalTime);

  void confirmForm() {
    ref.keepAlive().close();
  }
}
