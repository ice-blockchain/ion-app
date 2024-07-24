import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/model/send_nft_form_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_nft_form_provider.g.dart';

@riverpod
class SendNftFormController extends _$SendNftFormController {
  @override
  SendNftFormData build() {
    final walletId = ref.watch(selectedWalletIdNotifierProvider);
    final walletsData = ref.watch(walletsDataNotifierProvider);

    final wallet = walletsData[walletId]!;

    return SendNftFormData(
      selectedNft: mockedNftsDataArray[0],
      selectedNetwork: NetworkType.eth,
      wallet: wallet,
      address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
      arrivalTime: 15,
    );
  }

  void selectNft(NftData nft) => state = state.copyWith(selectedNft: nft);

  void selectNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);

  void updateAddress(String address) => state = state.copyWith(address: address);

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);
}
