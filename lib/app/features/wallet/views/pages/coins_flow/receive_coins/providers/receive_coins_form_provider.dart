import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/model/receive_coins_form_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_coins_form_provider.g.dart';

@riverpod
class ReceiveCoinsFormController extends _$ReceiveCoinsFormController {
  @override
  ReceiveCoinsFormData build() {
    return ReceiveCoinsFormData(
      selectedCoin: mockedCoinsDataArray[0],
      selectedNetwork: NetworkType.eth,
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
    );
  }

  void selectCoin(CoinData coin) => state = state.copyWith(selectedCoin: coin);

  void selectNetwork(NetworkType network) =>
      state = state.copyWith(selectedNetwork: network);
}
