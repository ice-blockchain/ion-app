import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/receive_coins_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_coins_form_provider.g.dart';

@riverpod
class ReceiveCoinsFormController extends _$ReceiveCoinsFormController {
  @override
  ReceiveCoinsData build() {
    return ReceiveCoinsData(
      selectedCoin: mockedCoinsDataArray[0],
      selectedNetwork: NetworkType.eth,
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
    );
  }

  void setCoin(CoinData coin) => state = state.copyWith(selectedCoin: coin);

  void setNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);
}
