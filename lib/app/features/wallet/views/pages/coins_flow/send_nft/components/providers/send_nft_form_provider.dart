import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/model/send_nft_form_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_nft_form_provider.g.dart';

@Riverpod(keepAlive: true)
class SendNftFormController extends _$SendNftFormController {
  @override
  SendNftFormData build() {
    return SendNftFormData(
      selectedNft: mockedNftsDataArray[0],
      selectedNetwork: NetworkType.eth,
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
      arrivalTime: 15,
    );
  }

  void selectCoin(NftData nft) => state = state.copyWith(selectedNft: nft);

  void selectNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);

  void updateAddress(String address) => state = state.copyWith(address: address);

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);
}
